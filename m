Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC0D78F58;
	Tue, 29 Apr 2025 17:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946018; cv=none; b=WkIlXEvYgn6JKQu0mfpyl1N3GcDo0/q6VK1C1PI8P6oFJ5dTRjIR+03shEZwOm06UGw1Iz3gHmjSllMzsobden7NtC8ZBbj8eDMNM6lvualDmRMYoUgL9X3VhhWe06p14Kd7vuNWm4e+FlsfEKWsF40z4NSsZRH9l0yVAwKZ4eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946018; c=relaxed/simple;
	bh=Ju9aScZZyGdXKDqwXbvIWoOLtMKq+ISNvIz9Q+fVZfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jh1szksahVYuydNkG/vnkyEpawUlTafxibjqsjUic7FDQCi7MM0260szobD8B+6uUvwLoXl4OD+hRyHBM1GSIr5HE2iJA5vrIV9KMMYzcaWotZRYis/6U4CXcNYy8cFy2s1aytvUwSbIzffL5JGusRV3SHc/2LlQtAmL30vO9X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATJainuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATJainuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380B4C4CEE3;
	Tue, 29 Apr 2025 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946017;
	bh=Ju9aScZZyGdXKDqwXbvIWoOLtMKq+ISNvIz9Q+fVZfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATJainukEX11u6mDajxxYzs2JTt0sVjFnrk9aX2udolMoLn5ILyRovwSo09F6IWr9
	 LP/+bpWiJWTKApBmXoZTrMR+YFQWcw9JG+XlrC/Nt1vWG43BG5cDi4wV+wbGTm9iLt
	 R77FfqBEygHzwYMhrlMZg5TvSUC+o/szA11ecFKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tiffany Y. Yang" <ynaffit@google.com>,
	stable <stable@kernel.org>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.14 127/311] binder: fix offset calculation in debug log
Date: Tue, 29 Apr 2025 18:39:24 +0200
Message-ID: <20250429161126.240233855@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 170d1a3738908eef6a0dbf378ea77fb4ae8e294d upstream.

The vma start address should be substracted from the buffer's user data
address and not the other way around.

Cc: Tiffany Y. Yang <ynaffit@google.com>
Cc: stable <stable@kernel.org>
Fixes: 162c79731448 ("binder: avoid user addresses in debug logs")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Tiffany Y. Yang <ynaffit@google.com>
Link: https://lore.kernel.org/r/20250325184902.587138-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -6373,7 +6373,7 @@ static void print_binder_transaction_ilo
 		seq_printf(m, " node %d", buffer->target_node->debug_id);
 	seq_printf(m, " size %zd:%zd offset %lx\n",
 		   buffer->data_size, buffer->offsets_size,
-		   proc->alloc.vm_start - buffer->user_data);
+		   buffer->user_data - proc->alloc.vm_start);
 }
 
 static void print_binder_work_ilocked(struct seq_file *m,


