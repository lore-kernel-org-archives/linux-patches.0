Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EB6DDB1;
	Thu, 13 Jun 2024 11:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278736; cv=none; b=MMbggRoVwukqHEM+zIzuiNw8B+EuszkFrGdVMlu4AzZI40ZdGphkQlkXRyeOZo0Pvz7vttHA44DagyQsEDwKj53nvnSMztEiyaCFVPCdAuAqghVK9Ku1j+MgVy3h+KpxY0tpipmLwApW6J7yDBi6emdcwssLyn60UdM7cThDM08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278736; c=relaxed/simple;
	bh=8T35qAmhyxcvTEqVwU7eOi64rynfbpEElJw/1ffbjzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWgAyQz+HH9f7ToYVWgQGCNH20MSlAK0klIjporNsZYNrVcGzI1w9NE9zIylL3hU+7pzAWdFEy6MzBQjn/UVzReAn2w1Yf41bl6AZl12578EzcLniEDFMBK836W2VvB2P3NJkh92+CfTsIOHq8GiHpKxTvA49EAZKLvOxs7aSuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nffZW9qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nffZW9qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A80EC2BBFC;
	Thu, 13 Jun 2024 11:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278736;
	bh=8T35qAmhyxcvTEqVwU7eOi64rynfbpEElJw/1ffbjzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nffZW9qeH6nsT3wrk5c1g1GUL59xKj0h1xZr/9iR/ENTOPX7jf98NxsyGQee0dLxm
	 8tfche7ITbH0Eet5gx4tsyqJMHA5jYPYVDoTR/PExTfobQfFAW8S4LCarbiEqYl7QP
	 0cVg4a+gvKc+dfWGlRygd5ZY05GmxfFAOdrb95F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Fang <derek.fang@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 012/213] ASoC: dt-bindings: rt5645: add cbj sleeve gpio property
Date: Thu, 13 Jun 2024 13:31:00 +0200
Message-ID: <20240613113228.457773638@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit 306b38e3fa727d22454a148a364123709e356600 ]

Add an optional gpio property to control external CBJ circuits
to avoid some electric noise caused by sleeve/ring2 contacts floating.

Signed-off-by: Derek Fang <derek.fang@realtek.com>

Link: https://msgid.link/r/20240408091057.14165-2-derek.fang@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/sound/rt5645.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/rt5645.txt b/Documentation/devicetree/bindings/sound/rt5645.txt
index a03f9a872a716..bfb2217a9a658 100644
--- a/Documentation/devicetree/bindings/sound/rt5645.txt
+++ b/Documentation/devicetree/bindings/sound/rt5645.txt
@@ -16,6 +16,11 @@ Optional properties:
   a GPIO spec for the external headphone detect pin. If jd-mode = 0,
   we will get the JD status by getting the value of hp-detect-gpios.
 
+- cbj-sleeve-gpios:
+  a GPIO spec to control the external combo jack circuit to tie the sleeve/ring2
+  contacts to the ground or floating. It could avoid some electric noise from the
+  active speaker jacks.
+
 - realtek,in2-differential
   Boolean. Indicate MIC2 input are differential, rather than single-ended.
 
@@ -64,6 +69,7 @@ codec: rt5650@1a {
 	compatible = "realtek,rt5650";
 	reg = <0x1a>;
 	hp-detect-gpios = <&gpio 19 0>;
+	cbj-sleeve-gpios = <&gpio 20 0>;
 	interrupt-parent = <&gpio>;
 	interrupts = <7 IRQ_TYPE_EDGE_FALLING>;
 	realtek,dmic-en = "true";
-- 
2.43.0



