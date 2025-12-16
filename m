Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D1734F46C;
	Tue, 16 Dec 2025 11:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885645; cv=none; b=qu1KM/+VQPNNxNiWUJfyC8qRZeF81j/5yr8Zm6EYPdlt7RJTHq/kybJz5iAD/+lwldn9jEaVS7YnQWQrNbHDx4tlmYBjC6AaPgNQLzzpIg2M/hWXcIG6pFvbB5qrBC0zJA+7QW/AvGFysEqU8ErOgy5oD7BglK9WL+ru2EQLP2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885645; c=relaxed/simple;
	bh=9ksJJ6g4r6EqGcviOxmzF/3YXKnuWUmoeeqoIDKdFfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7JUm8UHwbErTG2D3Q+AKWitg4wd1Xwa3GhYQdjYL4S8TZCEF0H1DdLJefPcvkj6omoau6EKdGnUw71aMK+6rnk2bgyAVmh3ziKMhrhr3Q8bUTXn6NtU3ub4cH3R+nCkkMHlIQjtA/YqpfN2Pdu3BQl1IKkdrGflT9vhKbD492A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJEdDzGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJEdDzGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47336C4CEF1;
	Tue, 16 Dec 2025 11:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885645;
	bh=9ksJJ6g4r6EqGcviOxmzF/3YXKnuWUmoeeqoIDKdFfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJEdDzGq0TVuviLCnE0su1Dfiyg9AYKsAXNqCV96Hjsbxef/jpuR99qdp5i7mbUZW
	 icPBaBpYsDEp49t8FhL1MwXW5mZcxAGQ+t0W74b0C8EUCjvT8dpk0FGPulqygJqhrB
	 lIoEOhA7IA0juQ305BkDGo3cWxVigyz51TMjqKzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 200/507] ARM: dts: stm32: stm32mp157c-phycore: Fix STMPE811 touchscreen node properties
Date: Tue, 16 Dec 2025 12:10:41 +0100
Message-ID: <20251216111352.754311042@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit e40b061cd379f4897e705d17cf1b4572ad0f3963 ]

Move st,adc-freq, st,mod-12b, st,ref-sel, and st,sample-time properties
from the touchscreen subnode to the parent touch@44 node. These properties
are defined in the st,stmpe.yaml schema for the parent node, not the
touchscreen subnode, resolving the validation error about unevaluated
properties.

Fixes: 27538a18a4fcc ("ARM: dts: stm32: add STM32MP1-based Phytec SoM")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Link: https://lore.kernel.org/r/20250915224611.169980-1-jihed.chaibi.dev@gmail.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/st/stm32mp157c-phycore-stm32mp15-som.dtsi    | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/st/stm32mp157c-phycore-stm32mp15-som.dtsi b/arch/arm/boot/dts/st/stm32mp157c-phycore-stm32mp15-som.dtsi
index bf0c32027baf7..370b2afbf15bf 100644
--- a/arch/arm/boot/dts/st/stm32mp157c-phycore-stm32mp15-som.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp157c-phycore-stm32mp15-som.dtsi
@@ -185,13 +185,13 @@ touch@44 {
 		interrupt-parent = <&gpioi>;
 		vio-supply = <&v3v3>;
 		vcc-supply = <&v3v3>;
+		st,sample-time = <4>;
+		st,mod-12b = <1>;
+		st,ref-sel = <0>;
+		st,adc-freq = <1>;
 
 		touchscreen {
 			compatible = "st,stmpe-ts";
-			st,sample-time = <4>;
-			st,mod-12b = <1>;
-			st,ref-sel = <0>;
-			st,adc-freq = <1>;
 			st,ave-ctrl = <1>;
 			st,touch-det-delay = <2>;
 			st,settling = <2>;
-- 
2.51.0



