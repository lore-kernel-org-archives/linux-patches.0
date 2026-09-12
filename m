Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8992035F5F7;
	Sat, 12 Sep 2026 10:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208670; cv=none; b=LBUc18SvGvve3V9HjIdVWMpBtH7KeWF5SBoubg1ZLXOpHZ1t3G3P/lGsf4bJa3c2af7AgqWfiNUraZw9cipU+9RvIxlMJsUk8xQptqFHYuTfizKZUE35JLd8ycs5U7SCT4b1qv9lJX/rfNUC7jicNracaltTirbDG+Z8TB8Hbx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208670; c=relaxed/simple;
	bh=HU95dgIfk25RM2mnkoBZ1Rww8R0nCq2AzkuLwvdhaD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i10dmwgPZZNPuCckkznzovwU6puDfi5KgKQ3uotN40YnSzABJZZ2cs3hD7JQaQjWu5nHqzhru3Y87NgOEYjIuoLsRp8Q9O/q+QbFx63kVTlDIZg8G7SJpPHyaVNIyg3g/f/xxPk1cTvPeZulKQdXe2KUxLKFcYCJgOwJiXE8GbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eS7//+FL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eS7//+FL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6B81F000FF;
	Sat, 12 Sep 2026 10:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208669;
	bh=g1VZgNQSCYH12IaatkN/ObfbYRGc7o6HRNPU2SAUlNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eS7//+FLv1vFDK+G24J9g1deA4VGTxC23CFZgf6EZaGdNUrM5cqLrJkIIqApGcfh+
	 4k8fU7ypvk5yeMbzmAm9BX7aphspYHtlXAxmDk90iPg3bThXxD1GhNT8rt35bJBWFx
	 f1xH4lRKjgzjE49PeUM/bifakkaO7UXlmyF+c3Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0664/1518] arm64: dts: qcom: sdm632-motorola-ocean: Fix LED default trigger property
Date: Sat, 12 Sep 2026 08:47:13 +0200
Message-ID: <20260912065638.455185072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit c82ea31fb783d9ce4080eca1a7bb855f4648fc28 ]

The correct property name is "linux,default-trigger", not
"default-trigger". Fix it to avoid DT checker warnings and let the OSes
consume the intended information.

Fixes: 3176c4d6b9be ("arm64: dts: qcom: sdm632: Add device tree for Motorola G7 Power")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260717-topic-june26_dts_fixes-v2-3-797cd46e5d9f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts b/arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts
index 2f55db0c8ce35..9ea3e5e76bf9e 100644
--- a/arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts
+++ b/arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts
@@ -130,7 +130,7 @@ led-controller@36 {
 
 		led: led@1 {
 			reg = <1>;
-			default-trigger = "backlight";
+			linux,default-trigger = "backlight";
 			function = LED_FUNCTION_BACKLIGHT;
 			led-sources = <0 1 2>;
 		};
-- 
2.53.0



