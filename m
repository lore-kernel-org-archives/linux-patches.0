Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFDB1D079F;
	Wed,  2 Oct 2024 13:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877209; cv=none; b=X4lV4rcSvaaea8FPkTwqDt2yiiFXssji8TzbNvCUNDCTbyu1ERdAy6JiODh3ZRKKXBDHEnjCvUtTfqcA3Rnxa8yrRnD/1B1EHnZMVhGSoXhg8zIetG3836nrKoSuMra2RuGMVK9iGa+4ZluHTRr5uuLRFT8f9pirXCHm8moWSg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877209; c=relaxed/simple;
	bh=fHKTrE7rh1oFprpefY8oJEFshBC8rA5Wqgi1u8PVH8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0H225Swl3d9aenIytsvI2YgMM3+nIMEckthAEjDvkiw2K/djeo99GkB1/+Krm9ett9JsztYYVAnZF+d9s1l6ORR43VpyYoeQisURtSWAtq+tBDPpi9JFY/eukKjhZNfnMz/lWsvNHuiU1FhpCywBEU12gjyNhOhZ1niF6/eKhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNXvN2QD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNXvN2QD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DACC4CEC2;
	Wed,  2 Oct 2024 13:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877209;
	bh=fHKTrE7rh1oFprpefY8oJEFshBC8rA5Wqgi1u8PVH8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNXvN2QD2jsYHgUOh9AGa1Y9aSanT0TCojqsAuDljbC3PTDhxf9J1RQRQaTOe2OSi
	 knPxosV6pHAoyqsbYiAqbjUQFMI09LwjKehNWDO9Rwm4XLZEtrI/8S2aZfcwy7Ctvc
	 hqwWnt+T9Rx85SZ55p1zxLMgLX+ndZe3vkfN60LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.11 694/695] Documentation: KVM: fix warning in "make htmldocs"
Date: Wed,  2 Oct 2024 15:01:32 +0200
Message-ID: <20241002125850.224430230@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit efbc6bd090f48ccf64f7a8dd5daea775821d57ec upstream.

The warning

 Documentation/virt/kvm/locking.rst:31: ERROR: Unexpected indentation.

is caused by incorrectly treating a line as the continuation of a paragraph,
rather than as the first line in a bullet list.

Fixed: 44d174596260 ("KVM: Use dedicated mutex to protect kvm_usage_count to avoid deadlock")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/virt/kvm/locking.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -25,6 +25,7 @@ The acquisition orders for mutexes are a
   must not take either kvm->slots_lock or kvm->slots_arch_lock.
 
 cpus_read_lock() vs kvm_lock:
+
 - Taking cpus_read_lock() outside of kvm_lock is problematic, despite that
   being the official ordering, as it is quite easy to unknowingly trigger
   cpus_read_lock() while holding kvm_lock.  Use caution when walking vm_list,


