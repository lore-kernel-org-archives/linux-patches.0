Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776FF1DEFEE;
	Wed, 19 Feb 2025 08:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954449; cv=none; b=oWb7iojIJCciNXujfSeTSuG+PCs0MU4Oa1Qy1Ya74UYumHEHDSNBArQH9YsvbipWm9nrQ4GSCASI2eHHa1dBweZah4AV5uLBHWQsn9u2LajxNFfih12E9dyHpINs4SE4seN8WG3qeVniwn3nt/mdLwDgUNU4jsjCu9rS0jA1jVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954449; c=relaxed/simple;
	bh=UMrvIM/6lptAWvc0HUFd6h9ispo/mIB2i8eUoq5cJ1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ufk2rYK8SoqRAM/SalWupPXCc+B2OsL9eElg8kM0ZWSX8qbzbFN57FrFtzxxFe2K+8P1ms7MH1OJ5B6fzT6BjfcMmlzzHHviyakUr2dPFF/HJRKkA240ogB57ZPGhSs74cjODTgRrwdARPhLOpJIM42B/pOgfqdWvXnwwNHiIhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hDsPStf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hDsPStf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8503BC4CED1;
	Wed, 19 Feb 2025 08:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954448;
	bh=UMrvIM/6lptAWvc0HUFd6h9ispo/mIB2i8eUoq5cJ1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hDsPStfLZlljqyoE9NsvXmBAZ/9JGURMArhpxbMM76f6M84n7UmOXlljSCxkufee
	 K9FgguRbIiKwKuCtNgIEXlsB28MkxAl9pIxPy3SKyDFSiVyR75A+oDYA1DwXqo+VoR
	 lyO5K2zwkOPc8bGVXj3lVVtwZtxtE+nlWZlkhor0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Varadarajan Narayanan <quic_varada@quicinc.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 177/274] regulator: qcom_smd: Add l2, l5 sub-node to mp5496 regulator
Date: Wed, 19 Feb 2025 09:27:11 +0100
Message-ID: <20250219082616.516370478@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Varadarajan Narayanan <quic_varada@quicinc.com>

commit b0eddc21900fb44f8c5db95710479865e3700fbd upstream.

Adding l2, l5 sub-node entry to mp5496 regulator node.

Cc: stable@vger.kernel.org
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Varadarajan Narayanan <quic_varada@quicinc.com>
Link: https://patch.msgid.link/20250205074657.4142365-2-quic_varada@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/regulator/qcom,smd-rpm-regulator.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/regulator/qcom,smd-rpm-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/qcom,smd-rpm-regulator.yaml
@@ -22,7 +22,7 @@ description:
   Each sub-node is identified using the node's name, with valid values listed
   for each of the pmics below.
 
-  For mp5496, s1, s2
+  For mp5496, s1, s2, l2, l5
 
   For pm2250, s1, s2, s3, s4, l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11,
   l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22


