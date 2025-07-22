Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DFF2C9A;
	Tue, 22 Jul 2025 14:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193112; cv=none; b=IODUx+FIyaJXct6WE54X/biyHcu0WkNzyZGUpZI7Xqe1CUcOAaEpJ9Yl2HTnmJvtCckZ+F7mX0auABk7S4gVTCTNR+zgNdnXe0yEgBrYpmZbg259Ve14rZ7D8xg4+KRkrWuwQGtILFHmQm2QAbf6Ltfjelhym6WhpC6hI3/7iPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193112; c=relaxed/simple;
	bh=1DhEOC4e5PL2JdwZ2sDYyb8YAqL7VmYD9Y4Sw4Otwe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7YJE7MCoAY5twXE2Vd0zVvt8DlUICjj9webe/z3ZoKzE+paYZXrgZJ7Dd33Bj8xIw6mGd0ohb3C6IdMo6yOUZRG4cIwQk4/6iuNbwpEjG01h33zHSBEYBu1diaCvq+JxvoytDpm1baurtmrYh0i9stpZHqHv3Xn3s/1Xu0dZkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJlwg3hi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJlwg3hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D77C4CEF5;
	Tue, 22 Jul 2025 14:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193112;
	bh=1DhEOC4e5PL2JdwZ2sDYyb8YAqL7VmYD9Y4Sw4Otwe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJlwg3hiJLKRhqvj8mpcAS7t+hr9jyQWFXBIv5Lr+yxGi6tgeYJsWVR19Kzlt7kAv
	 NbJaMaOOVELoNyWITCa4cE5WRTY8yzT7cmFlCgGt9BoR1YldEQgk07bi1B5N55VcGO
	 PaKWlEqb/4MUdmHtsXRhil8PqHON5O+Ktv8z3xdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 154/158] i2c: omap: fix deprecated of_property_read_bool() use
Date: Tue, 22 Jul 2025 15:45:38 +0200
Message-ID: <20250722134346.459996003@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit e66b0a8f048bc8590eb1047480f946898a3f80c9 upstream.

Using of_property_read_bool() for non-boolean properties is deprecated
and results in a warning during runtime since commit c141ecc3cecd ("of:
Warn when of_property_read_bool() is used on non-boolean properties").

Fixes: b6ef830c60b6 ("i2c: omap: Add support for setting mux")
Cc: Jayesh Choudhary <j-choudhary@ti.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
Link: https://lore.kernel.org/r/20250415075230.16235-1-johan+linaro@kernel.org
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1454,7 +1454,7 @@ omap_i2c_probe(struct platform_device *p
 				       (1000 * omap->speed / 8);
 	}
 
-	if (of_property_read_bool(node, "mux-states")) {
+	if (of_property_present(node, "mux-states")) {
 		struct mux_state *mux_state;
 
 		mux_state = devm_mux_state_get(&pdev->dev, NULL);


