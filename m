Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7056920F067;
	Tue, 26 Aug 2025 12:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212664; cv=none; b=frsLfl+C5A4Y89/xj2bsFHg6VWzfvTCRdKegXKwV2ZW78PndSGC95J8dOcuSzJZGI0HbaA0T92Dq4d8NMVkpkyo2Tg9nQqa6zojJgX98lR347T1/kMXrte6/P4R0ihPYbv73arbioX2BZOSPBK47NqhervminNNWdUBiJTDijCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212664; c=relaxed/simple;
	bh=vk6smnBsUtODtetJliy+lBkXmK5o2O7E0UElFxtQnrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5+JmkX7HjhPa8TNUpYZ6ca5C1cBdhNSOBLkcbPOEZAvfHNYfSYYAvwbncJSQWggYb4Uj+KfUAfSwyIJjSfSSvh6h0LxpFL/kb50nA2OI9GTay4bQnbL5+DmCz7CPyCvNDecCa7lHlG1LsaW6ehEyAVVOetrXc9M0UNP59D7VY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1dfHQ+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1dfHQ+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03669C4CEF4;
	Tue, 26 Aug 2025 12:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212664;
	bh=vk6smnBsUtODtetJliy+lBkXmK5o2O7E0UElFxtQnrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1dfHQ+wM1Lk51e+GpVczNENe+8A2PiZbIcKPssa5xKDWK+eFVjy0XTnOB2+HwhxQ
	 CIK2sqL6i80F3UdmokPjS7y1U6fOYo79MrFgOh6J1YKL+vh/oKnlXH9Zso2DEE+dvw
	 KRCGY60JcM+Z6uygmUHQFur8CFxqaIU0akERuccU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.6 025/587] PCI: Extend isolated function probing to LoongArch
Date: Tue, 26 Aug 2025 13:02:54 +0200
Message-ID: <20250826110953.593509871@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


