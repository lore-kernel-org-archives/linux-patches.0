Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11393302779;
	Wed, 28 Jan 2026 15:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615756; cv=none; b=ZwH+nQ4bGJr4M1F1o77osX6OjfbkZAAWG93kwEyCFbEdmWnxT8DaXTAwHv64a2kQ9e1dOS2UomGE6a3yzu1/6Ud8aPiS0yBPD/rePPQCRyBg2SFhpPBfHVan/0aHIME+G28mOJtL4GEuf01dnuipo3VW0SKRM43Vu1nXKFHC/YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615756; c=relaxed/simple;
	bh=8d04OtOTmV0ipVrJzr47hNUtDh1jLUVzZRG7am6H3iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTv/M73USLNozibCWexffM45bSl3kD/KZxeA9LOUNIzgvVV4w6dntwDymBfP+QXXpfImbgSbkovMEBwWXMcyIv/ELqW5W5n3xW/zWAzouQuR4q+jxB51ELhvGTcEWQt+uwuREyW3qMCchA5N12kbUZVfdA+1OmjM3qUmlLzC7Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OrBHFjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OrBHFjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC99C4CEF1;
	Wed, 28 Jan 2026 15:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615756;
	bh=8d04OtOTmV0ipVrJzr47hNUtDh1jLUVzZRG7am6H3iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2OrBHFjkONnVX1W6DqaAzoVZLx9O+3uKtbElMlmq0XshLdqajT4IQjF+EqFzhjFDu
	 RUeYtGBlvWowZH+SFA5gr5KX9f54NPvpMXWbSSI7UUjGko5NYVHqzwkPtkE57vP3Xq
	 kIytUPm6iNCCTTd8KAj2HdqqBQRlJT74Hetpuuco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Geraldo Nascimento <geraldogabriel@gmail.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.18 062/227] arm64: dts: rockchip: remove redundant max-link-speed from nanopi-r4s
Date: Wed, 28 Jan 2026 16:21:47 +0100
Message-ID: <20260128145346.573942622@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Geraldo Nascimento <geraldogabriel@gmail.com>

commit ce652c98a7bfa0b7c675ef5cd85c44c186db96af upstream.

This is already the default in rk3399-base.dtsi, remove redundant
declaration from rk3399-nanopi-r4s.dtsi.

Fixes: db792e9adbf8 ("rockchip: rk3399: Add support for FriendlyARM NanoPi R4S")
Cc: stable@vger.kernel.org
Reported-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/6694456a735844177c897581f785cc00c064c7d1.1763415706.git.geraldogabriel@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dtsi
@@ -71,7 +71,6 @@
 };
 
 &pcie0 {
-	max-link-speed = <1>;
 	num-lanes = <1>;
 	vpcie3v3-supply = <&vcc3v3_sys>;
 };


