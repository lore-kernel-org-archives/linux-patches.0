Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1685432ED21;
	Tue,  2 Sep 2025 13:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820204; cv=none; b=pmm0WiJk2JfniB9AqItKoubSHIabIWVjiRUgLFMfsiK3SwEeYwbQuG0cqjiz+fLElpSwZwLdydjVfWROBzeAJYiRkE4VXKWVdRe/nd/c9QEUonm71Hi1/rHwPyYon5nn+TR17dzRCt+PWWWaBpbIGT2+PDl+RG9MNbeW4ns2Ajs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820204; c=relaxed/simple;
	bh=LKxNw+0XBs68aqRYVR4UOuFEVn4ZmbAXEASIVQZqJjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDyaWURnVUSQajMxBee3Juhdk0FivsM8yotNEQZ0iyVKYBF+zljrZBOq59Femu6HkTEClO+0AMn4652sm0SbN1qPVTjjUAD4fjqxiLtq7jWdIpn42LZ62rpgKe1KTjuNUOF64kk9f3r3RDrdv9W4pioxUHeuGaGHs2AvXhr8OT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5EZQDRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5EZQDRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD93C4CEF4;
	Tue,  2 Sep 2025 13:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820203;
	bh=LKxNw+0XBs68aqRYVR4UOuFEVn4ZmbAXEASIVQZqJjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5EZQDRfnSpocCGboI7ag4KFBeolOCpK/UBMa5u4TUm4yTUIlrwKyq8+EQUQkHcRx
	 I+nFWVy/6Zz9L+DF6ZNG9eX4qUcsppIN8n5wak3s6ncoOxtvTjAp5pnNf2m4lt/BFJ
	 XqTEwE5h0AQAKCKFreKAzXty+Jjd6zDQLJQYnr9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 03/75] mips: dts: lantiq: danube: add missing burst length property
Date: Tue,  2 Sep 2025 15:20:15 +0200
Message-ID: <20250902131935.246448426@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 7b28232921782aa38048249132899c337405eaa8 ]

The upstream dts lacks the lantiq,{rx/tx}-burst-length property. Other
issues were also fixed:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: etop@e180000 (lantiq,etop-xway): 'interrupt-names' is a required property
	from schema $id: http://devicetree.org/schemas/net/lantiq,etop-xway.yaml#
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: etop@e180000 (lantiq,etop-xway): 'lantiq,tx-burst-length' is a required property
	from schema $id: http://devicetree.org/schemas/net/lantiq,etop-xway.yaml#
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: etop@e180000 (lantiq,etop-xway): 'lantiq,rx-burst-length' is a required property
	from schema $id: http://devicetree.org/schemas/net/lantiq,etop-xway.yaml#

Fixes: 14d4e308e0aa ("net: lantiq: configure the burst length in ethernet drivers")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/lantiq/danube_easy50712.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/mips/boot/dts/lantiq/danube_easy50712.dts b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
index 1ce20b7d05cb8..d8b3cd69eda3c 100644
--- a/arch/mips/boot/dts/lantiq/danube_easy50712.dts
+++ b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
@@ -87,8 +87,11 @@ etop@e180000 {
 			reg = <0xe180000 0x40000>;
 			interrupt-parent = <&icu0>;
 			interrupts = <73 78>;
+			interrupt-names = "tx", "rx";
 			phy-mode = "rmii";
 			mac-address = [ 00 11 22 33 44 55 ];
+			lantiq,rx-burst-length = <4>;
+			lantiq,tx-burst-length = <4>;
 		};
 
 		stp0: stp@e100bb0 {
-- 
2.50.1



