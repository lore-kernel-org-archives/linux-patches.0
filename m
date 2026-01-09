Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FDC32936C;
	Fri,  9 Jan 2026 12:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961139; cv=none; b=cq9O6zDq4EJVPxyHS4KLETRRGgQXyXVE9pyaH6XrA5HKCYg9hDkE0GMlVbPqcqDpaz8FQg0ewDYGJHTuGJmihmoRk2hae6Cu9aP82I4MOWM2/PlpA+QUDqxfsgGijb+cRzhpd3uMbsHEaah6NTL4P4G5IMI4GSkyVbbYyjauML4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961139; c=relaxed/simple;
	bh=+Q7onqfWLGym7rA6qNVsMHITnNL/x4DW5ECL26dAXJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZ7jMm6KNi1g95JrKVVTKQQ0YLRgINIo8pCNhwmN0zYDpjfQNH+xmn5XyLI3QoOA+90jQPu9X7FayLk+AtyV0ijf9el1v8MzvKVlJNebo+23iMQ4ba7h3i1UXQlS4t1Eaq3p+t3wQK+7XHHqVn77yRR9kj9iKL/5VbmOVzzQXu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfTIG6yw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfTIG6yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD78C4CEF1;
	Fri,  9 Jan 2026 12:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961139;
	bh=+Q7onqfWLGym7rA6qNVsMHITnNL/x4DW5ECL26dAXJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfTIG6ywLJ8eMUAEaDvY848GnGzqJrpq5bMLgi3amyAKSG3ketZSicCN1qpoJeMN4
	 lKc3HU50taPGG7xJ+00AM1eJRfHB265rh751uACpwB+EnKlhiwdR+iEncWMTQ06P2Y
	 8+rH8gqN8R1g4q5kfBclUd9gdbteXBllpib6AWIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 649/737] ARM: dts: microchip: sama7g5: fix uart fifo size to 32
Date: Fri,  9 Jan 2026 12:43:08 +0100
Message-ID: <20260109112158.433960691@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/microchip/sama7g5.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/microchip/sama7g5.dtsi
+++ b/arch/arm/boot/dts/microchip/sama7g5.dtsi
@@ -811,7 +811,7 @@
 				dma-names = "tx", "rx";
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
-				atmel,fifo-size = <16>;
+				atmel,fifo-size = <32>;
 				status = "disabled";
 			};
 		};
@@ -837,7 +837,7 @@
 				dma-names = "tx", "rx";
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
-				atmel,fifo-size = <16>;
+				atmel,fifo-size = <32>;
 				status = "disabled";
 			};
 		};


