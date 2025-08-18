Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9D9310640;
	Mon, 18 Aug 2025 12:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521459; cv=none; b=NrdG/BUewT+DItrbh/oy1I6lbtQCP+dkNZ2vKGqDY09EPuvR1JhKLCJB75WpkWV3ZOA+KZvBj6wH7ZLWxM48LNKmQoyhdDoVzXE13jA7T7fW6xEk+zHbhd9BWLYGUp7mHXrD+QN6X9oLHx/zErbm8l0OrQZ2uuRez1zsdNfrA8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521459; c=relaxed/simple;
	bh=bL6amZkqR3Bx+gQyH/iOyx+kxN3Oj2L5Lksh6LWSm4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEohbc2xl4jhya3Gu2hQoTaHiwuO7t4kop5SAjUHtJZjUnoIPkGtBovoXhPVUt5cuOVLyG79oU7KVWKsjYUAg6dFuvHfyrGGhR4SshvxMQ1HLyUoHR9ctQz7i+yqCOyd+HkW5WYEx+cFa3xydmwpqUJlwv6IV0pwKABHkkTv9L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXEC+Wno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXEC+Wno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86B5C4CEEB;
	Mon, 18 Aug 2025 12:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521459;
	bh=bL6amZkqR3Bx+gQyH/iOyx+kxN3Oj2L5Lksh6LWSm4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXEC+Wnoe8S42Lnwmxi59gUOEufl0QoZLT7JiUx92oM7FPbUVUTgCeTy/FBBMYdN0
	 M/l+dzMRegO5ePpbeU6NflIDf2ZudPvuAiPRXzMDyyswsBNE5r3/zOt/B5E4p2ifZW
	 YscL6rahXcA1o9utz4jd/2+0yA8YFCYkftYkMdSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.12 026/444] PCI: Extend isolated function probing to LoongArch
Date: Mon, 18 Aug 2025 14:40:52 +0200
Message-ID: <20250818124449.915220388@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


