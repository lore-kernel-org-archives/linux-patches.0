Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B9236AE0;
	Mon, 15 Apr 2024 14:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191661; cv=none; b=W5RrQIcp/ASGNNuzlBFkfURnQ0jeNI6ieTixVhBIGYon9iMQa2osvtccOW78JyIwys2nI6XNbkdAebH8NJC1tOXyGOYfFCzXzHK1qYDRdUYOFPI9P8kDCl9d2cWtCvqHc7DSL0lrjBwrjDUfBKvdwmNLnIeXDjHdoS+QfKxjmHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191661; c=relaxed/simple;
	bh=VZ+0TqftzDbTXeR2dIxPzj1coQSsn2PWdYlAFBTgJlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMoghd3dBYPe6kXQeeVPz8kIRQqa/Bpc38SG0jXMi5D31VgCFk/29C4Ot59FI6sybzOYC9N00iOgJQ0QeF2BJUAXnWcNuFYaJppuAJz22WgnNNOxIG1p/cevDq/Sx/9Hu8VG5EGTrqyKYF8NPXwi16Y7mpWffwO8VMt4JLgU6iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5M9g5kB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5M9g5kB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73BFC113CC;
	Mon, 15 Apr 2024 14:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191661;
	bh=VZ+0TqftzDbTXeR2dIxPzj1coQSsn2PWdYlAFBTgJlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5M9g5kBARXwjMZVPtddtVGByNC4XCkUy8eauAt+M/CJ4zjsF5sJHgBLxaGc78HyM
	 29OfXZ3HlNE4m7v24jY/Q7sa+BAa/Smwioig5ieZbY/0WtiF7qCIXvY3nxwv+IF7q3
	 9/bIOCwrUXko1ZF9ZCcv470SWO/pPECJV8fa3TM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 006/122] ARM: dts: imx7s-warp: Pass OV2680 link-frequencies
Date: Mon, 15 Apr 2024 16:19:31 +0200
Message-ID: <20240415141953.566107097@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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


