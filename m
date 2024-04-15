Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FFA77F15;
	Mon, 15 Apr 2024 14:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191086; cv=none; b=ipDGNA932+liZb84BVN699AfuSn7543pOk5l91AgxrRAab5z0XPBlFZ3gw0xMrHoujLm92rnrg0dPlgchPpw5JyvwYAj6YhL3pXUsLkU75SvMbrJnlvAlujGrNcwQ23lF0W8Y7p5a4SSDryyiN5A7UuPteE9OA3tuSkmZ/HpCTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191086; c=relaxed/simple;
	bh=CQtwwECl0ReMXs2kpiaO00vA7etkPT7nxvImrwZSSk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKuhhUSOmwsDPF+hWa7pRxgSIyChQ7Ghuau+iXoKlcIOLxJ5LiLpXZl2jZe2foEriDd7mF5jGRwc7Y56NgD8svc77Fgu0DVmsAxdtlTOs3waHarXHpz2bCEaRq8y40VUVIuRnm9igxuMpEOAEphn0rTEmE7ceK7hNe19WTZMnEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apciiIec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apciiIec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD40C113CC;
	Mon, 15 Apr 2024 14:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191085;
	bh=CQtwwECl0ReMXs2kpiaO00vA7etkPT7nxvImrwZSSk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apciiIecUSlxwsTKiW8UaXbnS6o6EEkO70AYU+ZX70cdpsM+2XCtEDuHs9pTP7Wzf
	 7aUdmr95t5mM6QOlm4GSpR5PHqLpr3C9OepTdAkOaRATTdtw31l2ErB1c7xwj9S96o
	 lV817JpK7wy1idKrdRbuqJdsysiQ3xIA6l7PvzWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.8 010/172] ARM: dts: imx7s-warp: Pass OV2680 link-frequencies
Date: Mon, 15 Apr 2024 16:18:29 +0200
Message-ID: <20240415142000.295901798@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

commit 135f218255b28c5bbf71e9e32a49e5c734cabbe5 upstream.

Since commit 63b0cd30b78e ("media: ov2680: Add bus-cfg / endpoint
property verification") the ov2680 no longer probes on a imx7s-warp7:

ov2680 1-0036: error -EINVAL: supported link freq 330000000 not found
ov2680 1-0036: probe with driver ov2680 failed with error -22

Fix it by passing the required 'link-frequencies' property as
recommended by:

https://www.kernel.org/doc/html/v6.9-rc1/driver-api/media/camera-sensor.html#handling-clocks

Cc: stable@vger.kernel.org
Fixes: 63b0cd30b78e ("media: ov2680: Add bus-cfg / endpoint property verification")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/nxp/imx/imx7s-warp.dts |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/nxp/imx/imx7s-warp.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx7s-warp.dts
@@ -210,6 +210,7 @@
 				remote-endpoint = <&mipi_from_sensor>;
 				clock-lanes = <0>;
 				data-lanes = <1>;
+				link-frequencies = /bits/ 64 <330000000>;
 			};
 		};
 	};


