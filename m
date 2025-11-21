Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14AE34D3B6;
	Fri, 21 Nov 2025 13:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732678; cv=none; b=qW5IXqhUNZ4u2fJmiE8QWMubbsiK379gb2ED94ObB9U/N2WtNrtk38gdAOtrTSXimTAef3yMaCHH/+SNv1LmrLSgd2D1jCT77s+yc64cTWMXjX8Y4Ctzy1RcjAoUgGiFwiquaXZvmYcsjtGbdyXiixiGYF2DgHlIjUEpk/EEH/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732678; c=relaxed/simple;
	bh=OrwIA6uf0CDBHafEoqVsFkgI95K2r3Xa8q0IMiVYZDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eg+TCyDlSX3syhWzulKOcHOW61bgUZ8pCxs+SCtgo8gHXlL/bV+o04+dmKBTwanEqUAg3XX8lp3skFH/rkyASJnm8M2nEuMmVkxZF2ejjzySugtJnqQBUBRCVkqACNn8kiD3L2ovUzAwz72DRDHL1PznnfpJxru6HXwzlbWpLNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcMnfkQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcMnfkQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF57C4CEF1;
	Fri, 21 Nov 2025 13:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732678;
	bh=OrwIA6uf0CDBHafEoqVsFkgI95K2r3Xa8q0IMiVYZDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcMnfkQFtpObeHUhcRBf/ktDcPAEpxNUS0zWOpF+XTKT16oupozuqV7Y4czTrm24A
	 vK6tTE+Ewtzi49SXTyylvghP79P6mg7c60W8h+PnNQoz+DXJxJPnK8ZhqdIqrqtU/i
	 fxZ6oIpwum/GC4VOTuxpeoMii83oqY8rn8pDXupM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/529] mips: lantiq: danube: add missing properties to cpu node
Date: Fri, 21 Nov 2025 14:07:50 +0100
Message-ID: <20251121130237.104065401@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit e8dee66c37085dc9858eb8608bc783c2900e50e7 ]

This fixes the following warnings:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: cpus: '#address-cells' is a required property
	from schema $id: http://devicetree.org/schemas/cpus.yaml#
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: cpus: '#size-cells' is a required property
	from schema $id: http://devicetree.org/schemas/cpus.yaml#
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: cpu@0 (mips,mips24Kc): 'reg' is a required property
	from schema $id: http://devicetree.org/schemas/mips/cpus.yaml#

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/lantiq/danube.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/boot/dts/lantiq/danube.dtsi b/arch/mips/boot/dts/lantiq/danube.dtsi
index 7a7ba66aa5349..0a942bc091436 100644
--- a/arch/mips/boot/dts/lantiq/danube.dtsi
+++ b/arch/mips/boot/dts/lantiq/danube.dtsi
@@ -5,8 +5,12 @@
 	compatible = "lantiq,xway", "lantiq,danube";
 
 	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
 		cpu@0 {
 			compatible = "mips,mips24Kc";
+			reg = <0>;
 		};
 	};
 
-- 
2.51.0



