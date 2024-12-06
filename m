Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCEB1514CE;
	Fri,  6 Dec 2024 15:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498518; cv=none; b=BibRT3cqSJaxKAqFDEZJ8kVeMal/zYPaBdJ7R0YqRGx/1lK53sTILyLcoDYDA4KSuNWanZDRpGh0g6OWWgkaMFnV8XgpAI/b2APk35ILeE9Is67uXYVgdAQAxL8X5790EoBdrknP/ZbUi6CM4FQqqXdPowEMoOcwXwPncO+qwF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498518; c=relaxed/simple;
	bh=iyKAl4L4e1ZNhut6bJac8v7OodQRVUqaFGsZwWmr1Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCerZlUyzPaJKWr9J6K1Unqa8ysG1Wc/SM89Z7hEFKH2Nty+CwhGy4UFJYiMzNCdZ74yUGvoNIwq/AEmmbt9o2y2NciRLRvspNI4od5rMPqZkUo8/RtX+J+3Npne0vFr8M6WkAvmAUFen4hlycQjRaPU8fud4WX73rxDbBMAzVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCLjFlw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCLjFlw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD51C4CED1;
	Fri,  6 Dec 2024 15:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498518;
	bh=iyKAl4L4e1ZNhut6bJac8v7OodQRVUqaFGsZwWmr1Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCLjFlw9IfRY9CaGFtQ+Gr8Z8WdXSyV926ReQ6bHNSo8bTBnXKzB1oazpa416vjjF
	 OK/Pq3O0Ocr1MybrExWXND7LiAZtptLnzFejxvZbuVrycqh9ssIjULFF/+sN//3qtZ
	 3UnReTGo7A/sjHc9yTFx1bB5MxwW3CtV26r6TmTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.6 608/676] arm64: dts: ti: k3-am62-verdin: Fix SD regulator startup delay
Date: Fri,  6 Dec 2024 15:37:07 +0100
Message-ID: <20241206143717.122858842@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 2213ca51998fef61d3df4ca156054cdcc37c42b8 upstream.

The power switch used to power the SD card interface might have
more than 2ms turn-on time, increase the startup delay to 20ms to
prevent failures.

Fixes: 316b80246b16 ("arm64: dts: ti: add verdin am62")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20241024130628.49650-1-francesco@dolcini.it
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -134,7 +134,7 @@
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
 		regulator-name = "+V3.3_SD";
-		startup-delay-us = <2000>;
+		startup-delay-us = <20000>;
 	};
 
 	reg_sdhc1_vqmmc: regulator-sdhci1-vqmmc {


