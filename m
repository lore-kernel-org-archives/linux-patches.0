Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAA11A83ED;
	Tue, 26 Aug 2025 13:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214208; cv=none; b=g+V8RPkRuCbNhrbL0GsSg+LG6GWGFoMWliTtMhSyVLJC8lYX3PWZfMAof4iRFPl/hQX6kWo/6kIT85qtfwyNnUbQ9gcndLS5x2r6tOtJi+wwBwYx2i/wFmptCALHd9VaniV96NTIMKJVGSlQvpr/xdzvIzJGR3INd2EYZlK5O20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214208; c=relaxed/simple;
	bh=8mPZ1Xpu/oRj1GQElPC9vQWdZKRTUd/jDLXseqtCn8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3+f5vySQy2wEfDXBgd1aryC5WnDFWJ6jNeG7wCkBKIsorfs9sGPlrDd1rwrT3HeDXARPI5kz+KSR3SGLtLe0cvWHrujcvGLDcMf2tjxB/T08obMZJhRiFCtoeDbSOmUX2RO5SlD5tV45p+7CGiF9DdwnzvQxI3aM1YvCFxYHOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyQ4zK3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyQ4zK3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42FFC4CEF1;
	Tue, 26 Aug 2025 13:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214208;
	bh=8mPZ1Xpu/oRj1GQElPC9vQWdZKRTUd/jDLXseqtCn8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyQ4zK3+bRPlE7+SN6R+ztuHu30rUK0oFe8Xd9EVA25t/wMRTSa14uVGvSlorB6Bu
	 sQsNhKjDK9OhYEzgLFgNXDkQHNB+7cYTdVHrCLFTbkSXpZz/a3dG/bHZc7yIytqFgL
	 bR/bUrBAeitrXJA9hzWWNveJCIn4eysPSlT3S6Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.1 019/482] PCI: Extend isolated function probing to LoongArch
Date: Tue, 26 Aug 2025 13:04:32 +0200
Message-ID: <20250826110931.263868638@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit a02fd05661d73a8507dd70dd820e9b984490c545 upstream.

Like s390 and the jailhouse hypervisor, LoongArch's PCI architecture allows
passing isolated PCI functions to a guest OS instance. So it is possible
that there is a multi-function device without function 0 for the host or
guest.

Allow probing such functions by adding a IS_ENABLED(CONFIG_LOONGARCH) case
in the hypervisor_isolated_pci_functions() helper.

This is similar to commit 189c6c33ff42 ("PCI: Extend isolated function
probing to s390").

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250624062927.4037734-1-chenhuacai@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hypervisor.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/hypervisor.h
+++ b/include/linux/hypervisor.h
@@ -37,6 +37,9 @@ static inline bool hypervisor_isolated_p
 	if (IS_ENABLED(CONFIG_S390))
 		return true;
 
+	if (IS_ENABLED(CONFIG_LOONGARCH))
+		return true;
+
 	return jailhouse_paravirt();
 }
 


