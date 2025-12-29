Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A263533064D;
	Mon, 29 Dec 2025 16:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025828; cv=none; b=tMVtKeMXX/4bPDniVnXd9FVkig8YYnYJOegduwHIz1kws1u4XnAjsB9xxJvg/AKGldd4ytBWgr5YzVLzZl9Iqs1oM7189qp/XPM8Lp9BcKy2mHjgUDAjyq0x4fC6ImXVaku3fW7yVLZtPeaHkbM+nn7UesUO7dOT0cd24h4gOHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025828; c=relaxed/simple;
	bh=HkynEkO0qhkw5lynPKGcmMYlnLIVVzUfSigj3+2uQ/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aulMWqg4B+0blagW2l39tz5+uA1VuoO/u3JFbbT4RbtBmOfMAXwwhsioqbtAMDJhNMZTUV0Z1ZlKnauGulFy/sEosI7CAchPkWI3hC4SeTHVFpFq6wxawY79vN1ZaDQ4rKsrLaW+aPQvY/ZTrjmxL93Ixl5BV2ER8n4WGMGoC4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcWzLs5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcWzLs5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9EEC4CEF7;
	Mon, 29 Dec 2025 16:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025828;
	bh=HkynEkO0qhkw5lynPKGcmMYlnLIVVzUfSigj3+2uQ/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcWzLs5qvqQ5rzoBbs6hV+2sHb2+sALBequqrGnjaE68STER0WQoE1cBIVI2ukrBb
	 M5NEFzM/8aeZI7vXViijQzaG8t97e1calj63COlrc3MW1qUfN8tpCRcpF+/9TKMTNP
	 VnRqn2yMYxhRN8cJSxgg3hbypW1cBD8bBg06Y7FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Matlack <dmatlack@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 344/430] KVM: selftests: Forcefully override ARCH from x86_64 to x86
Date: Mon, 29 Dec 2025 17:12:26 +0100
Message-ID: <20251229160736.988154594@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 17e5a9b77716564540d81f0c1e6082d28cf305c9 upstream.

Forcefully override ARCH from x86_64 to x86 to handle the scenario where
the user specifies ARCH=x86_64 on the command line.

Fixes: 9af04539d474 ("KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR")
Cc: stable@vger.kernel.org
Reported-by: David Matlack <dmatlack@google.com>
Closes: https://lore.kernel.org/all/20250724213130.3374922-1-dmatlack@google.com
Link: https://lore.kernel.org/r/20251007223057.368082-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -6,7 +6,7 @@ ARCH            ?= $(SUBARCH)
 ifeq ($(ARCH),$(filter $(ARCH),arm64 s390 riscv x86 x86_64 loongarch))
 # Top-level selftests allows ARCH=x86_64 :-(
 ifeq ($(ARCH),x86_64)
-	ARCH := x86
+	override ARCH := x86
 endif
 include Makefile.kvm
 else


