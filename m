Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C774342CA9;
	Tue, 11 Nov 2025 01:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823560; cv=none; b=Gu33ofsMz08xgbvIeaYwX+yCpN66w6nm2JTV6IUnl0orKCdf0zUq8mClvP6+FOeKHCXb8AmRRlwVsmoLXWrna7PQfBUJs4fBayp1dDg7yBFVKUg8StRXwmo07sNLlMmfKNwNjKT2AzXUL3ufkbMkay5QU0X1yn7/ETXDev1eV0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823560; c=relaxed/simple;
	bh=EMYVeX5kFQj8nCTXOKL8iiD9hgSCvJGLsDP8RZf3z+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLfQoimXsMgfBy5oY3r1IF2HYiErXTK/GoIgT2QowZjTSoE3Nln+vupwIM5bxtO28rR7gcUs6YEw0a/qRBF376ClrTyq3vZBb8Ki9xNEgLCnhQtA/32+FhRJnQhrqKqhBRXy2Fg5pH87ugySjpoj7eYcE3MYNwVwn+yFcZzV+wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLh9eWFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLh9eWFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1354DC16AAE;
	Tue, 11 Nov 2025 01:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823560;
	bh=EMYVeX5kFQj8nCTXOKL8iiD9hgSCvJGLsDP8RZf3z+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLh9eWFPIWOA+cWNDyhPKlSMO9kkxNgD8IXvKnGtK1yXaVibVdSmLou4C7zzDuI6X
	 qFrUPw+S10mB8sjt7aW/7Ce35NSI/bzbmviASea2ePahDNG6FuzV2XGRq2u7sKkrL6
	 e/Kli32+IMRH+R2BXMDMUc4lCMy3Wj+fXtNe5kBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 270/565] mips: lantiq: danube: add model to EASY50712 dts
Date: Tue, 11 Nov 2025 09:42:06 +0900
Message-ID: <20251111004532.961549090@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit cb96fd880ef78500b34d10fa76ddd3fa070287d6 ]

This fixes the following warning:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: / (lantiq,xway): 'model' is a required property
	from schema $id: http://devicetree.org/schemas/root-node.yaml#

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/lantiq/danube_easy50712.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/boot/dts/lantiq/danube_easy50712.dts b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
index c4d7aa5753b04..ab70028dbefcf 100644
--- a/arch/mips/boot/dts/lantiq/danube_easy50712.dts
+++ b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
@@ -4,6 +4,8 @@
 /include/ "danube.dtsi"
 
 / {
+	model = "Intel EASY50712";
+
 	chosen {
 		bootargs = "console=ttyLTQ0,115200 init=/etc/preinit";
 	};
-- 
2.51.0



