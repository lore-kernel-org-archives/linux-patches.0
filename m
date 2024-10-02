Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB15F1D1313;
	Wed,  2 Oct 2024 14:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880642; cv=none; b=R0YwAV9TR0f/3Scro74/f2fakI3a1QYta8aF/kQGS+fuiJxv1aAiOE667Jyta1qsIm0qroQwndSwXF4aN2BleWPrwFpQEvB4Y142+3lGUMoPnak8zbqVz1pYo3VaCoEztbLfP+avIvP1LxQTBlRYtJswAvc27iPVa9RSV3gr4Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880642; c=relaxed/simple;
	bh=2QbgEd4K5NjxoLSekWuQCmQsJ1Jl9WoziYFQlKiVT9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jELG/wtzCK5bdoQkoMnxr7X1oMA0fYnrY0lUJVf7aWqf/hb+Tnv4d5gULlp6am+KPyBgSg4/0ZdiLn3ZxiOCz0HG6UleD8Zq00lZBWUEfMXZps5LMA3p6oCTeOfvzYiEPtNnfIMZBVzD5EP15RQhN+rgFsr5Xgdad2GSfF7LhVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrvtrRRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrvtrRRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A02C4CECE;
	Wed,  2 Oct 2024 14:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880641;
	bh=2QbgEd4K5NjxoLSekWuQCmQsJ1Jl9WoziYFQlKiVT9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrvtrRRCLjgHapbNwpsq67eVD4yLxNZ0vRbgN6fobIRpw0lzQE7pEh/s481QzY2eP
	 Gm236RfjncWr7GdsUUSdwtJh2WgdZkCP4EW/FTFmJE9rAGoXcJIasHl3q1kpuz+nqU
	 v/eVq0Hwk67egg/5lK7yXZs132v7OuO3517fCzC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 528/538] Documentation: KVM: fix warning in "make htmldocs"
Date: Wed,  2 Oct 2024 15:02:47 +0200
Message-ID: <20241002125813.288411938@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


