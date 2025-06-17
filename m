Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBDA2FA658;
	Tue, 17 Jun 2025 16:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178495; cv=none; b=tI6yLuA2R0uhjUC2YTpoAv6pZFKlUrIVkcqhhYMFu8PqlyPF8o8F9DE6byzVUS1iajY0qk92CKW0iH5+igjgk+/N7vlzFC2vEG7Ol0rCVsNLCHs9ruiAK1zkX87jr1Lucwh/FpHF+1xMPkYF1BjovbzSDyrklI7Jmx+FNfp++ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178495; c=relaxed/simple;
	bh=6SVDE9Rd6ZXqCTE5t2j29VtSgOEgG4tA/aZdcTJpa4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H5qlpH1p+86BI5O2ebKrPKEFVzD4+QVbR1zEe8MdcfNlDcB1a+FKnHdMgR+mXOph1oyOh/UwTn5M+TpVc5k7BSHuB+Hl3FSQbcDk1fQfsMsnbUBtkpslFSoJWZ6/rEAAb4b0JeQbeWfsBQPMha+HqbLp8DKVwDKf+efuqH1ispQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6gl3rhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6gl3rhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1DEC4CEE3;
	Tue, 17 Jun 2025 16:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178494;
	bh=6SVDE9Rd6ZXqCTE5t2j29VtSgOEgG4tA/aZdcTJpa4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6gl3rhrF1yYY0PpiUSHCRTlEzaPppvMCg3qATHUs17hMS2eBy5MqgBIy1Tuws8r5
	 2V7hOWsYHbzrzEEAjmfhFTruKaqPX77T8bW7ARj+bwbdXDqxTGOTcW+RwbRpigtosr
	 Qp8yB43XP++rZrthM5QFXaHfut3xcq2vYsqFtAEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 507/512] regulator: dt-bindings: mt6357: Drop fixed compatible requirement
Date: Tue, 17 Jun 2025 17:27:53 +0200
Message-ID: <20250617152440.159681787@linuxfoundation.org>
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

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

commit 9cfdd7752ba5f8cc9b8191e8c9aeeec246241fa4 upstream.

Some of the regulators on the MT6357 PMIC currently reference the
fixed-regulator dt-binding, which enforces the presence of a
regulator-fixed compatible. However since all regulators on the MT6357
PMIC are handled by a single mt6357-regulator driver, probed through
MFD, the compatibles don't serve any purpose. In fact they cause
failures in the DT kselftest since they aren't probed by the fixed
regulator driver as would be expected. Furthermore this is the only
dt-binding in this family like this: mt6359-regulator and
mt6358-regulator don't require those compatibles.

Commit d77e89b7b03f ("arm64: dts: mediatek: mt6357: Drop regulator-fixed
compatibles") removed the compatibles from Devicetree, but missed
updating the binding, which still requires them, introducing dt-binding
errors. Remove the compatible requirement by referencing the plain
regulator dt-binding instead to fix the dt-binding errors.

Fixes: d77e89b7b03f ("arm64: dts: mediatek: mt6357: Drop regulator-fixed compatibles")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://patch.msgid.link/20250514-mt6357-regulator-fixed-compatibles-removal-bindings-v1-1-2421e9cc6cc7@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/regulator/mediatek,mt6357-regulator.yaml |   12 ----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/Documentation/devicetree/bindings/regulator/mediatek,mt6357-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/mediatek,mt6357-regulator.yaml
@@ -33,7 +33,7 @@ patternProperties:
 
   "^ldo-v(camio18|aud28|aux18|io18|io28|rf12|rf18|cn18|cn28|fe28)$":
     type: object
-    $ref: fixed-regulator.yaml#
+    $ref: regulator.yaml#
     unevaluatedProperties: false
     description:
       Properties for single fixed LDO regulator.
@@ -112,7 +112,6 @@ examples:
           regulator-enable-ramp-delay = <220>;
         };
         mt6357_vfe28_reg: ldo-vfe28 {
-          compatible = "regulator-fixed";
           regulator-name = "vfe28";
           regulator-min-microvolt = <2800000>;
           regulator-max-microvolt = <2800000>;
@@ -125,14 +124,12 @@ examples:
           regulator-enable-ramp-delay = <110>;
         };
         mt6357_vrf18_reg: ldo-vrf18 {
-          compatible = "regulator-fixed";
           regulator-name = "vrf18";
           regulator-min-microvolt = <1800000>;
           regulator-max-microvolt = <1800000>;
           regulator-enable-ramp-delay = <110>;
         };
         mt6357_vrf12_reg: ldo-vrf12 {
-          compatible = "regulator-fixed";
           regulator-name = "vrf12";
           regulator-min-microvolt = <1200000>;
           regulator-max-microvolt = <1200000>;
@@ -157,14 +154,12 @@ examples:
           regulator-enable-ramp-delay = <264>;
         };
         mt6357_vcn28_reg: ldo-vcn28 {
-          compatible = "regulator-fixed";
           regulator-name = "vcn28";
           regulator-min-microvolt = <2800000>;
           regulator-max-microvolt = <2800000>;
           regulator-enable-ramp-delay = <264>;
         };
         mt6357_vcn18_reg: ldo-vcn18 {
-          compatible = "regulator-fixed";
           regulator-name = "vcn18";
           regulator-min-microvolt = <1800000>;
           regulator-max-microvolt = <1800000>;
@@ -183,7 +178,6 @@ examples:
           regulator-enable-ramp-delay = <264>;
         };
         mt6357_vcamio_reg: ldo-vcamio18 {
-          compatible = "regulator-fixed";
           regulator-name = "vcamio";
           regulator-min-microvolt = <1800000>;
           regulator-max-microvolt = <1800000>;
@@ -212,28 +206,24 @@ examples:
           regulator-always-on;
         };
         mt6357_vaux18_reg: ldo-vaux18 {
-          compatible = "regulator-fixed";
           regulator-name = "vaux18";
           regulator-min-microvolt = <1800000>;
           regulator-max-microvolt = <1800000>;
           regulator-enable-ramp-delay = <264>;
         };
         mt6357_vaud28_reg: ldo-vaud28 {
-          compatible = "regulator-fixed";
           regulator-name = "vaud28";
           regulator-min-microvolt = <2800000>;
           regulator-max-microvolt = <2800000>;
           regulator-enable-ramp-delay = <264>;
         };
         mt6357_vio28_reg: ldo-vio28 {
-          compatible = "regulator-fixed";
           regulator-name = "vio28";
           regulator-min-microvolt = <2800000>;
           regulator-max-microvolt = <2800000>;
           regulator-enable-ramp-delay = <264>;
         };
         mt6357_vio18_reg: ldo-vio18 {
-          compatible = "regulator-fixed";
           regulator-name = "vio18";
           regulator-min-microvolt = <1800000>;
           regulator-max-microvolt = <1800000>;


