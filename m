Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1031A2389;
	Thu, 15 Jan 2026 17:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498493; cv=none; b=W2s9ahrP5YiNLpwzDLS80x28zKHjH/y+7DoYHhoAqgV41FprAMRD9KE8VdK+56HKxcwzNTvweQxbDgxMBsLBZonHTSvVvL+zvBsbEod4/8GPZhh1r8X4xHMO0jriEHdujG8LNy1Ct0eKx+3E1w6fj7StY2uXQy8YK2TDiSkdWkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498493; c=relaxed/simple;
	bh=AjwLnz9OTkm2IwF4lqmvDNSmdjIvGCHxl4hEKuqCxJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cmdi3OAWVU0yYXn8A7hWStBxKk6KhEyOVRzNuukzqFrlj1Dhn0ye00MFL21NdUzouhYYC8DBdIEGsuAnhLhBMhpZIsyc3dr4eYVUZ2WTQK1m2hupaj/uQ0K62JZdObE7/62iHCMGj/7sSzFojRLo3FCrmhDFFp/KfSjE4yT4Qho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDkIwa8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDkIwa8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5EAC116D0;
	Thu, 15 Jan 2026 17:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498493;
	bh=AjwLnz9OTkm2IwF4lqmvDNSmdjIvGCHxl4hEKuqCxJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDkIwa8lL6+AuPQpyx2Gf/WsVpef3jE4ThwrrY9tWjNrSesLV+37tVY3QpQJs+12t
	 OuPqRgQzqR5M+JHbFGrrQMNSA5B+vVoaJ3h3W7Rjl73s52T4HQA2XWjUXKSkbJ3xI0
	 FkRpyBGNYOnFqMH+4AFb+BimPlL+v5qVp2co+Ly4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 450/554] ARM: dts: microchip: sama7g5: fix uart fifo size to 32
Date: Thu, 15 Jan 2026 17:48:36 +0100
Message-ID: <20260115164302.559275981@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@microchip.com>

[ Upstream commit 5654889a94b0de5ad6ceae3793e7f5e0b61b50b6 ]

On some flexcom nodes related to uart, the fifo sizes were wrong: fix
them to 32 data.

Fixes: 7540629e2fc7 ("ARM: dts: at91: add sama7g5 SoC DT and sama7g5-ek")
Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20251114103313.20220-2-nicolas.ferre@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/sama7g5.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/sama7g5.dtsi
+++ b/arch/arm/boot/dts/sama7g5.dtsi
@@ -375,7 +375,7 @@
 				dma-names = "tx", "rx";
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
-				atmel,fifo-size = <16>;
+				atmel,fifo-size = <32>;
 				status = "disabled";
 			};
 		};
@@ -400,7 +400,7 @@
 				dma-names = "tx", "rx";
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
-				atmel,fifo-size = <16>;
+				atmel,fifo-size = <32>;
 				status = "disabled";
 			};
 		};


