Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAC4BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1C8C433D2;
	Tue,  7 Mar 2023 19:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216275;
	bh=5/vYxG0d0VhyuEeTFEEZ+72FTBcf0IzUA4kufOOhIWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGyzT6b8NupkUK91vYLxvlq+QJgF72VZU6p62VgHkk0ZxmJJfOCsg4ie3tvtu8egX
	 3i2Q/D59YXIjJ/3BFChyw+dOR79N8I40SI2rIx/5yAL/9kg3szNLKor0g0EQ7Fy7+7
	 WakrGh4FMKczdmSYyRLgjoB8wcmQ/dnm3rJNPJ/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 5.15 530/567] docs: gdbmacros: print newest record
Date: Tue,  7 Mar 2023 18:04:26 +0100
Message-Id: <20230307165928.927719532@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Ogness <john.ogness@linutronix.de>

commit f2e4cca2f670c8e52fbb551a295f2afc9aa2bd72 upstream.

@head_id points to the newest record, but the printing loop
exits when it increments to this value (before printing).

Exit the printing loop after the newest record has been printed.

The python-based function in scripts/gdb/linux/dmesg.py already
does this correctly.

Fixes: e60768311af8 ("scripts/gdb: update for lockless printk ringbuffer")
Cc: stable@vger.kernel.org
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20221229134339.197627-1-john.ogness@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kdump/gdbmacros.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/kdump/gdbmacros.txt
+++ b/Documentation/admin-guide/kdump/gdbmacros.txt
@@ -312,10 +312,10 @@ define dmesg
 			set var $prev_flags = $info->flags
 		end
 
-		set var $id = ($id + 1) & $id_mask
 		if ($id == $end_id)
 			loop_break
 		end
+		set var $id = ($id + 1) & $id_mask
 	end
 end
 document dmesg


