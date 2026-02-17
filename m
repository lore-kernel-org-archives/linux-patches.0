Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F0234D4F8;
	Tue, 17 Feb 2026 20:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361099; cv=none; b=TQ74lSU3ZOQFdI2FhynXFjoYvEc7vrbchOXCtx89M/zbVEyPZNqidy6dIHHQJVqbAIsnG3rwd9BQSX+SoJI87UWXpTIoui/2sypvfzDaazgCI+TPIdC9ONKlKtiEJTO0EPPuIQvV/jy7y71YbVLeWnNTYRiW+e1rYJ8w7K1oguI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361099; c=relaxed/simple;
	bh=GC57wfqIzxrHnxJU7olCI6I1v0bqIA3Km+SbkT0edyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gp/qe8O5JtUhALK4lDgfI3O5KTIQU6qrqsH09hOtr57MM4qyEiXWiHGAvcOlSYBdoiRCrDRXiYX0zAxIGWFqzfEq25nMpEsHABL8jVfsag7k0TGWYJx9IWtY/UXqtcnBTp/R2TT38wUeRAbR6/8NH/C561okpwTQm0fqXcQBLcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKArNNLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKArNNLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF45C4CEF7;
	Tue, 17 Feb 2026 20:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361099;
	bh=GC57wfqIzxrHnxJU7olCI6I1v0bqIA3Km+SbkT0edyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKArNNLt1kHhie5v2GNflXHe/7x9bZpxw5KXxLxHNLRxTJlCzHR4+OKxFoMcFpBju
	 zczpS0LGUepLH+ZcIlYAJcYjNK3vybuicLo68lG9r5A8d04SMYi1uFZmD47t3ktpAh
	 vPGoY+NqtZ3rukye0RmHJ8eh9ECvvO1lA89JPJZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/39] PCI: endpoint: Remove unused field in struct pci_epf_group
Date: Tue, 17 Feb 2026 21:31:42 +0100
Message-ID: <20260217200004.216987634@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 328e4dffbeecc0f2cc5a149dee6c11a0577c9671 ]

In "struct pci_epf_group", the 'type_group' field is unused.

This was added, but already unused, by commit 70b3740f2c19 ("PCI: endpoint:
Automatically create a function specific attributes group").

Thus, remove it.

Found with cppcheck, unusedStructMember.

[kwilczynski: commit log]
Link: https://lore.kernel.org/linux-pci/6507d44b6c60a19af35a605e2d58050be8872ab6.1712341008.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 7c5c7d06bd1f ("PCI: endpoint: Avoid creating sub-groups asynchronously")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/pci-ep-cfs.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pci/endpoint/pci-ep-cfs.c
+++ b/drivers/pci/endpoint/pci-ep-cfs.c
@@ -23,7 +23,6 @@ struct pci_epf_group {
 	struct config_group group;
 	struct config_group primary_epc_group;
 	struct config_group secondary_epc_group;
-	struct config_group *type_group;
 	struct delayed_work cfs_work;
 	struct pci_epf *epf;
 	int index;


