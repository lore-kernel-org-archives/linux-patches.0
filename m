Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAF01DD9D3;
	Tue, 25 Mar 2025 12:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905988; cv=none; b=QP0RRT5Aayjv3a/nEpq5s7XDlhrnJSAdzGUnrcCquXFD0NUGn6lROdjewHJny7YsR7peSGPgmPXSOLQ3bTYV7wZydIume5JFiCYo4TEsHBnXce2nUwI2KnJ95DLPekBqBRWTFefkgrhLRQFys9aYer8ReQYE7PsslWEIJRP97OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905988; c=relaxed/simple;
	bh=B6eRi0UySarl63MbnzezSmzI4sX6DF1KoyAJN75Fk+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvxS1GkhBH+MlHpE0Mq4gA7TAS0Y2SerohgEwa6VHBKGil+JkLXRu6gJRVfMjF6fiQMnStBkUtJb1eruHe9U0pZD6rIMUNXC+nyMZqL7W5urZJx42OUbsfe6dBDlXtvkC5w7B30wjfoE3082Se68/mjwOob7PoEvf5CDcowGm5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+Ywuj3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+Ywuj3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEA4C4CEE4;
	Tue, 25 Mar 2025 12:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905987;
	bh=B6eRi0UySarl63MbnzezSmzI4sX6DF1KoyAJN75Fk+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+Ywuj3JSEILfHUbpVwjiCFruCJrrsascnhM5fLOAdy9T393ikCB0j13Q6F4hUvJ5
	 QmEsEB6+uFyASiWZPCQSrX98yuFjkIxOwR0nDMfm+CHtWfog9ftCVXdhDHumwmA+Hg
	 SfPP78HxCRY6YLeJhM9N3a9Xiq0GDSIlsjX7uv0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Klaassen <justin@tidylabs.net>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.13 073/119] arm64: dts: rockchip: fix u2phy1_host status for NanoPi R4S
Date: Tue, 25 Mar 2025 08:22:11 -0400
Message-ID: <20250325122150.922304580@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

From: Justin Klaassen <justin@tidylabs.net>

commit 38f4aa34a5f737ea8588dac320d884cc2e762c03 upstream.

The u2phy1_host should always have the same status as usb_host1_ehci
and usb_host1_ohci, otherwise the EHCI and OHCI drivers may be
initialized for a disabled usb port.

Per the NanoPi R4S schematic, the phy-supply for u2phy1_host is set to
the vdd_5v regulator.

Fixes: db792e9adbf8 ("rockchip: rk3399: Add support for FriendlyARM NanoPi R4S")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Klaassen <justin@tidylabs.net>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/20250225170420.3898-1-justin@tidylabs.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dtsi
@@ -115,7 +115,7 @@
 };
 
 &u2phy1_host {
-	status = "disabled";
+	phy-supply = <&vdd_5v>;
 };
 
 &uart0 {


