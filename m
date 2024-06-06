Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0051919EEA4;
	Thu,  6 Jun 2024 14:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683121; cv=none; b=nV4RdqWg6LWjwsR8HYP5GTz8zN0BStoP5DyW3peDhlzj09IOlJSE1fK5xRvrIz14UTgUYzEp29/CqYMYDy1hUL7zxsXlrTJhdRWc6m7pvJIGOdwg1mVBTrG+7Y3i4Hgm4rDuQJqwQaqGvNl25+bKrwcCL26391e+/Ff721nJQQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683121; c=relaxed/simple;
	bh=RChXLK7XOMxwCMLFWixu3YhfLPV7xTGhxVJfSbwCp8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlPGm9gvVCl7Au3GyfdvP3zw5Mpv0VWz1DeOHzyTXoE/WFyLzafoM+84wU7R9UxOv+DhggrMstWPEb63/DeJ2ZCRtyz2zOVb16O3PM1eL+tJGbunC6gg/aRpZ7ywKDqEpBJDFQcFAIYobYLL3Ge5QbWn65G1n4AngZGbHc63YcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ha99cTTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ha99cTTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6CCC2BD10;
	Thu,  6 Jun 2024 14:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683120;
	bh=RChXLK7XOMxwCMLFWixu3YhfLPV7xTGhxVJfSbwCp8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ha99cTTqnwje6nuIkCoPAmR0MyYnVG80BOYnML/zfNZWdLKRqwuMVpe+xpKIwzywM
	 fkDhyEV6BfRZ3Sk17WjyOz1zyN8+FyX76UC9pP9IIJFrN6ExTu7UdOiF9ixyY2VfPD
	 +INI4KBoMSkZGmpEDo+33Dz9v7NobIoy43HrRXEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Derek Fang <derek.fang@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/744] ASoC: dt-bindings: rt5645: add cbj sleeve gpio property
Date: Thu,  6 Jun 2024 15:55:31 +0200
Message-ID: <20240606131734.318246043@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 41a62fd2ae1ff..c1fa379f5f3ea 100644
--- a/Documentation/devicetree/bindings/sound/rt5645.txt
+++ b/Documentation/devicetree/bindings/sound/rt5645.txt
@@ -20,6 +20,11 @@ Optional properties:
   a GPIO spec for the external headphone detect pin. If jd-mode = 0,
   we will get the JD status by getting the value of hp-detect-gpios.
 
+- cbj-sleeve-gpios:
+  a GPIO spec to control the external combo jack circuit to tie the sleeve/ring2
+  contacts to the ground or floating. It could avoid some electric noise from the
+  active speaker jacks.
+
 - realtek,in2-differential
   Boolean. Indicate MIC2 input are differential, rather than single-ended.
 
@@ -68,6 +73,7 @@ codec: rt5650@1a {
 	compatible = "realtek,rt5650";
 	reg = <0x1a>;
 	hp-detect-gpios = <&gpio 19 0>;
+	cbj-sleeve-gpios = <&gpio 20 0>;
 	interrupt-parent = <&gpio>;
 	interrupts = <7 IRQ_TYPE_EDGE_FALLING>;
 	realtek,dmic-en = "true";
-- 
2.43.0



