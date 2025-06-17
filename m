Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C1C1ADC97;
	Tue, 17 Jun 2025 16:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177922; cv=none; b=rgWl+Eo/dyf47NTIqlFyqRKJKDopKEaTySCGfSvrHU/j15vAt2x5AIlcaJIR/qhRVT0WM5y1jvTOfdBdiIQbz2FlL6kATgdlO835/sCWDPOhvDgpxlWEtGaBNgx4Zzjziw+poXNEkLbZH2Yz/YWrqV6M9/RrMpGYlnzbOGn7MDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177922; c=relaxed/simple;
	bh=XB02xQIxNX5qjy7yk56avs8hTBEi0UXsRjMjlPQZYc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rfz8uuhif84HW4pZf2xRnTjW9WowEJdGBnHWBj0dWb3iwb/nILoZuZwh7F8aFEja3D8D14DdTYjgkAncsuKqS4S1tTfzWoPvS0UkAJApSaQhcytNI0J8ngsa9VELgMAxAbGncCk2M+FzSR4m6QlbiWnTlIYaIa2fbR/a15Gjig8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6szu7I5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6szu7I5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950DBC4CEE3;
	Tue, 17 Jun 2025 16:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177922;
	bh=XB02xQIxNX5qjy7yk56avs8hTBEi0UXsRjMjlPQZYc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6szu7I5JmfyWv8hXuHL0aGZeQInVj3OYbxdff++lDSoq+cAwp74OjeYJNkIwVSSo
	 atFie5DPyzk0z/KED1GSJuHWW2BiGzo5yi88rhrCegCUfE0iwMMX9iU1cwtcaIR3Ll
	 50Ai6i5UdvSydVeGbF8eMoDBcCv2kQber88AnnKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Trevor Gamblin <tgamblin@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 414/512] dt-bindings: pwm: adi,axi-pwmgen: Increase #pwm-cells to 3
Date: Tue, 17 Jun 2025 17:26:20 +0200
Message-ID: <20250617152436.358224229@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 664b5e466f915ad7fce87215ccfb038c47ace4fb ]

Using 3 cells allows to pass additional flags and is the normal
abstraction for new PWM descriptions. There are no device trees yet to
adapt to this change.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Trevor Gamblin <tgamblin@baylibre.com>
Link: https://lore.kernel.org/r/20241024102554.711689-2-u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Stable-dep-of: e683131e64f7 ("dt-bindings: pwm: adi,axi-pwmgen: Fix clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml b/Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml
index ec6115d3796ba..aa35209f74cfa 100644
--- a/Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml
+++ b/Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml
@@ -27,7 +27,7 @@ properties:
     maxItems: 1
 
   "#pwm-cells":
-    const: 2
+    const: 3
 
   clocks:
     maxItems: 1
@@ -44,5 +44,5 @@ examples:
        compatible = "adi,axi-pwmgen-2.00.a";
        reg = <0x44b00000 0x1000>;
        clocks = <&spi_clk>;
-       #pwm-cells = <2>;
+       #pwm-cells = <3>;
     };
-- 
2.39.5



