Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7C3218927;
	Tue, 12 Nov 2024 10:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408193; cv=none; b=a1Mkb3W8C06LZGUMhz9hhEXeXpui6Nts/EUHVKb9EdW0FAgdxpd+Zn4ZmTNtHU++xZirXxnF/jdQDFDI9rkaKvbRug6c1r5N+KsE6nmDRV1v87mcxnxb28KolTw2AED3iVzavzD+zzchVRjYFttFZyrXYkxCgppsX+jk5C5sg6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408193; c=relaxed/simple;
	bh=BDOqnn/PE2WGx59dZgGeMGkjTj5I685o7cJHsyI3aqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ptIIvnrWluka40VDf+r6KH1KSR/D4FCh2d+ZIsPFoD6NgyJ56eqfhdb8puhpnzQrtWrJoOS24ert5Rj6OeL2S0NzOaNnxeB5ifMkVAtVTpk4mz9/TWw1M4Fna7V1y4qdbaLS1/ZljQpHoKV6J6leVrhfs5rzVM2O4PAoMdRbiFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XG192Rys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XG192Rys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6828BC4CECD;
	Tue, 12 Nov 2024 10:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408193;
	bh=BDOqnn/PE2WGx59dZgGeMGkjTj5I685o7cJHsyI3aqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XG192Rys1t2M27uIeeV/rzb2neCRa9p4DSuByXrvaH9hwQU25yNbzGh6g28BQMFrz
	 PBARry49l7LDMIYCsPEzmlnvUTGIlyiTDNMJ+bSvJJmc2m5uP8/qvrYxdFAeylu2yr
	 ulEd/rmMzG3v1p+S1Dvfc1535R7xnY0uu5S+zcwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.11 088/184] can: {cc770,sja1000}_isa: allow building on x86_64
Date: Tue, 12 Nov 2024 11:20:46 +0100
Message-ID: <20241112101904.235920877@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Mühlbacher <tmuehlbacher@posteo.net>

commit 7b22846f8af5ab2f267de9eb209fb1835ee9978c upstream.

The ISA variable is only defined if X86_32 is also defined. However,
these drivers are still useful and in use on at least some modern 64-bit
x86 industrial systems as well. With the correct module parameters, they
work as long as IO port communication is possible, despite their name
having ISA in them.

Fixes: a29689e60ed3 ("net: handle HAS_IOPORT dependencies")
Signed-off-by: Thomas Mühlbacher <tmuehlbacher@posteo.net>
Link: https://patch.msgid.link/20240919174151.15473-2-tmuehlbacher@posteo.net
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/cc770/Kconfig   | 2 +-
 drivers/net/can/sja1000/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/cc770/Kconfig b/drivers/net/can/cc770/Kconfig
index 467ef19de1c1..aae25c2f849e 100644
--- a/drivers/net/can/cc770/Kconfig
+++ b/drivers/net/can/cc770/Kconfig
@@ -7,7 +7,7 @@ if CAN_CC770
 
 config CAN_CC770_ISA
 	tristate "ISA Bus based legacy CC770 driver"
-	depends on ISA
+	depends on HAS_IOPORT
 	help
 	  This driver adds legacy support for CC770 and AN82527 chips
 	  connected to the ISA bus using I/O port, memory mapped or
diff --git a/drivers/net/can/sja1000/Kconfig b/drivers/net/can/sja1000/Kconfig
index 01168db4c106..2f516cc6d22c 100644
--- a/drivers/net/can/sja1000/Kconfig
+++ b/drivers/net/can/sja1000/Kconfig
@@ -87,7 +87,7 @@ config CAN_PLX_PCI
 
 config CAN_SJA1000_ISA
 	tristate "ISA Bus based legacy SJA1000 driver"
-	depends on ISA
+	depends on HAS_IOPORT
 	help
 	  This driver adds legacy support for SJA1000 chips connected to
 	  the ISA bus using I/O port, memory mapped or indirect access.
-- 
2.47.0



