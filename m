Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526791640A
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzV/o+lo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17DEC433C7;
	Mon, 23 Oct 2023 11:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061684;
	bh=QBXptyPM/7TgDxA8LeJOj2iXbsHHLvVrVNla13WQ7Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzV/o+loSBEIRctGESycASQKGg5vXE9C7+1LhlSvx+I/XT8AArRHRZ0k67g/PkkY5
	 4tGaKMjrURhjxevH54rAn8beflhcIBJInE7jvCMsY+Qycb58zgykU2+mIwT5nNMnqS
	 FE1XZ0ykyNWNx+angC08CiAith3lrukzMI/SzFL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.garry@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/202] resource: Add irqresource_disabled()
Date: Mon, 23 Oct 2023 12:57:09 +0200
Message-ID: <20231023104830.095909853@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.garry@huawei.com>

[ Upstream commit 9806731db684a475ade1e95d166089b9edbd9da3 ]

Add a common function to set the fields for a irq resource to disabled,
which mimics what is done in acpi_dev_irqresource_disabled(), with a view
to replace that function.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/1606905417-183214-3-git-send-email-john.garry@huawei.com
Stable-dep-of: c1ed72171ed5 ("ACPI: resource: Skip IRQ override on ASUS ExpertBook B1402CBA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ioport.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 5135d4b86cd6a..f9bf374f96336 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -307,6 +307,13 @@ struct resource *devm_request_free_mem_region(struct device *dev,
 struct resource *request_free_mem_region(struct resource *base,
 		unsigned long size, const char *name);
 
+static inline void irqresource_disabled(struct resource *res, u32 irq)
+{
+	res->start = irq;
+	res->end = irq;
+	res->flags = IORESOURCE_IRQ | IORESOURCE_DISABLED | IORESOURCE_UNSET;
+}
+
 #ifdef CONFIG_IO_STRICT_DEVMEM
 void revoke_devmem(struct resource *res);
 #else
-- 
2.40.1



