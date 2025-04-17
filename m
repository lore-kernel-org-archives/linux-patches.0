Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CC1256C93;
	Thu, 17 Apr 2025 18:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914709; cv=none; b=Hl9HC41bnwfT17I2TS5sByQYGXwLKeqE9xO0+Dc58ywrxTvK7uAC4JSQ8xZL6XueVtg7B62wZIe0d3pufO8xxx1QTVBRCwLZ3aJnNkj3q8ZqMm/UcVyZ38K7Up+E0ixl7roIX0R0mvaCclHaqzkc0eO7hZSqRarGyIK+3gRluDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914709; c=relaxed/simple;
	bh=N04x1S6TVSJhoDg1bY//NeyzpL0+zjbQxOdWVpjcRdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8qjZYtNwByOPCbp+bzRWVlzS3fX2OcKnxcdPagfFt5BlOUwlwcr1v3IAsBBezqQQAGqX87va/4dX2GGTRc/bQoDI8MJQavQpiNbrwu/6zxwjXLRSwUj8fVnbt+i4LENmWTTPFdh36nMgWwTZ+mU603iyk7555KbxvpDxX810cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZV/BYzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZV/BYzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699EDC4CEE4;
	Thu, 17 Apr 2025 18:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914708;
	bh=N04x1S6TVSJhoDg1bY//NeyzpL0+zjbQxOdWVpjcRdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZV/BYzF0UZQI2jkZeVLuyPYKzixI7rc9koRdqL1M3J66F/CiCITvbQQ1nUi4maSE
	 84ZZ4Rue7La6vXBpgTVKaGbHIdp8tN8RQcfmWHOozYtKBTHKKQEMJA9Ssu2evfxDzJ
	 CzDY9a722z4+NOuUDmoTSp9bfMw54xd26gdlK6c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ninad Malwade <nmalwade@nvidia.com>,
	Ivy Huang <yijuh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.13 304/414] arm64: tegra: Remove the Orin NX/Nano suspend key
Date: Thu, 17 Apr 2025 19:51:02 +0200
Message-ID: <20250417175123.659500415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

From: Ninad Malwade <nmalwade@nvidia.com>

commit bb8a3ad25f098b6ea9b1d0f522427b4ad53a7bba upstream.

As per the Orin Nano Dev Kit schematic, GPIO_G.02 is not available
on this device family. It should not be used at all on Orin NX/Nano.
Having this unused pin mapped as the suspend key can lead to
unpredictable behavior for low power modes.

Orin NX/Nano uses GPIO_EE.04 as both a "power" button and a "suspend"
button. However, we cannot have two gpio-keys mapped to the same
GPIO. Therefore remove the "suspend" key.

Cc: stable@vger.kernel.org
Fixes: e63472eda5ea ("arm64: tegra: Support Jetson Orin NX reference platform")
Signed-off-by: Ninad Malwade <nmalwade@nvidia.com>
Signed-off-by: Ivy Huang <yijuh@nvidia.com>
Link: https://lore.kernel.org/r/20250206224034.3691397-1-yijuh@nvidia.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767.dtsi |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767.dtsi
@@ -227,13 +227,6 @@
 			wakeup-event-action = <EV_ACT_ASSERTED>;
 			wakeup-source;
 		};
-
-		key-suspend {
-			label = "Suspend";
-			gpios = <&gpio TEGRA234_MAIN_GPIO(G, 2) GPIO_ACTIVE_LOW>;
-			linux,input-type = <EV_KEY>;
-			linux,code = <KEY_SLEEP>;
-		};
 	};
 
 	fan: pwm-fan {


