Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18281D7E35;
	Tue, 29 Apr 2025 17:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949598; cv=none; b=qlH2zdp62U9RvYVD+azR4sms1Kg5kLOf08Jm577meXGvl3weNcbMk8nAyzJKppmhqqDrR2X0itLTOxhD44z5UCQ6HZKmJmsRp/DjT99b+G+6y4SaOK9z0ntM9tBAPgDruRi/pGDo4nG1i3kD2wOPFrvKCupBHEXunJeEGLT/PBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949598; c=relaxed/simple;
	bh=SGV86SQq9DPHFgF/sHTEmtA8Wu7h4NcBEkt1UGQUkmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IylIIqsEc0qgl6oIEDJ5mt4w0oKCRaPqs8h69q7tfQL3zUJ7hNHbpvrxd62oPPXQUhrHwiqpN3TOJ05L7RLHPH4UbYuQXlOw7SKt907EoeiKboanH/D95QrU+/4jAYbhCWJd+h2qxwu5F+Chso7f7hAi2/4apjNRGZ7jiI/+fEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gP4Zcd87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gP4Zcd87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DE8C4CEE3;
	Tue, 29 Apr 2025 17:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949597;
	bh=SGV86SQq9DPHFgF/sHTEmtA8Wu7h4NcBEkt1UGQUkmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gP4Zcd87+x1WqOs6uhdcgyd0Eif+IVljOQNzaQPzbD43wILTr8F7q14d3fKvu3Y7+
	 7Q7ybJp+Ciaj5NVgi4BhURvRCSxeVrOZnF74h5nyXbJ7Ej/c0V1qpjFPXCdaq1kB2W
	 84eKjXYIZYdBeC/hQaH79/tXt512+yxNxwBayKJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 369/373] MIPS: cm: Fix warning if MIPS_CM is disabled
Date: Tue, 29 Apr 2025 18:44:06 +0200
Message-ID: <20250429161138.309909042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

commit b73c3ccdca95c237750c981054997c71d33e09d7 upstream.

Commit e27fbe16af5c ("MIPS: cm: Detect CM quirks from device tree")
introduced

arch/mips/include/asm/mips-cm.h:119:13: error: ‘mips_cm_update_property’
	defined but not used [-Werror=unused-function]

Fix this by making empty function implementation inline

Fixes: e27fbe16af5c ("MIPS: cm: Detect CM quirks from device tree")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/mips-cm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/mips-cm.h
+++ b/arch/mips/include/asm/mips-cm.h
@@ -104,7 +104,7 @@ static inline bool mips_cm_present(void)
 #ifdef CONFIG_MIPS_CM
 extern void mips_cm_update_property(void);
 #else
-static void mips_cm_update_property(void) {}
+static inline void mips_cm_update_property(void) {}
 #endif
 
 /**


