Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25A31E3DF9;
	Tue,  3 Dec 2024 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242365; cv=none; b=IIPbeB+wr1A7lPjOL4RX+iSNV2Q5E8USO6CnCHMWZNpmfnuWKwWnhUWuc4SbJwvA+sFQsQP55HYy4pcNlJFv6LpHouxTb/HuJXjrB41HMJiICvTMOY4NMThnoTRHpLlaWLZWrnpEtUy09G77kx1k/OYEjSbIlVMQH3BsHdK+/+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242365; c=relaxed/simple;
	bh=uslBR82GjzzyvCraiKPRgTtiutiWnvaPby79pzqco8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVT9fRXL06h7m7VrHgXBNV8bOg5xA9ucMw7I2ptHRWzCQgIME4ye5wXZpffgyL3MBNtqSsbl5Sc4gPRADjaJz+haUXwnnDgniQ6krxo/aONETts705UxW4GQYEOs3tfQgatyVVExZXwwhBrnyxrzDVY2bJRgOQtOb1zj95V6C7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3nIAoZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3nIAoZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6277AC4CECF;
	Tue,  3 Dec 2024 16:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242364;
	bh=uslBR82GjzzyvCraiKPRgTtiutiWnvaPby79pzqco8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3nIAoZaWikwqlOb4FI0JHOjfSgQ8hVZWou6FfbA/aJQhu5XtMb7RR7TnHz7CluzL
	 wnf46JluAYuRN5Aj/0FWt0GNX7lKFAK5OtkE7f6IecWZ20arZQBpe0wtPmvo1bUy0D
	 2ejf3DEGhDirXVrw6/b4afZ/Mnvuh2FIWZ1znV8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Andreas Kemnade <andreas@kemnade.info>,
	Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 6.12 680/826] ARM: dts: omap36xx: declare 1GHz OPP as turbo again
Date: Tue,  3 Dec 2024 15:46:47 +0100
Message-ID: <20241203144810.282831524@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Kemnade <andreas@kemnade.info>

commit 96a64e9730c2c76cfa5c510583a0fbf40d62886b upstream.

Operating stable without reduced chip life at 1Ghz needs several
technologies working: The technologies involve
- SmartReflex
- DVFS

As this cannot directly specified in the OPP table as dependecies in the
devicetree yet, use the turbo flag again to mark this OPP as something
special to have some kind of opt-in.

So revert commit
5f1bf7ae8481 ("ARM: dts: omap36xx: Remove turbo mode for 1GHz variants")

Practical reasoning:
At least the GTA04A5 (DM3730) has become unstable with that OPP enabled.
Furthermore nothing enforces the availability of said technologies,
even in the kernel configuration, so allow users to rather opt-in.

Cc: Stable@vger.kernel.org
Fixes: 5f1bf7ae8481 ("ARM: dts: omap36xx: Remove turbo mode for 1GHz variants")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20241018214727.275162-1-andreas@kemnade.info
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/ti/omap/omap36xx.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/boot/dts/ti/omap/omap36xx.dtsi
+++ b/arch/arm/boot/dts/ti/omap/omap36xx.dtsi
@@ -72,6 +72,7 @@
 					 <1375000 1375000 1375000>;
 			/* only on am/dm37x with speed-binned bit set */
 			opp-supported-hw = <0xffffffff 2>;
+			turbo-mode;
 		};
 	};
 


