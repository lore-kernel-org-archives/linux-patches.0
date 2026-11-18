Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062127;
	b=Ce+w8HIARPee/dwWMILp9oRhud5Fz8VM1o1FkwLnKqdS8A+q80leLkxicFiD9SaXWjTF
	 LFW+1MhWGofgCnsCewN6zIVNiYDBW3hHh9FndeVJVPQh/9U4wYZLqpt42pgP7eABMIW4P
	 tkuULknFVTWfhoz7mbSmI7QYbLFEkTVbsjuX6HG1KfoQup79ZO3Kwji1NytaLPsajUjb5
	 Wj656Hf7tTPhUz6k57/DQJiT97r2AjVljxVAkDNolUcaXWMitaCA/Bvkdfx7kioOL7zmz
	 PopZMgLMUJ7Dxho/FafXP0ZuLI5F71uBCuhvimdqQWbthUOQpmnJU/iBe73m8ogU95Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W+6FEvOj3yU7bdU8yEHGoICuGD5hcTCllNtUzPVL4LQ=;
	b=P0Esv6HCD5r3u/gK9blxycXZi7aPC7wkCx4HG6+hXbV3BEdh6UsvaF3GwIU+YGBLpVLt
	 KPjF2QVZVn3BEu5YjxJPPyUwWSsCLstNG2ofQfzbilwigmtshV/QtblJudEQtOYP4ZsMj
	 GKvF9xwUxlUNNeCutyeAprNCTkYnVYQn0LCcl+3e5JTOFkLqYLkVB5yhxDKZ31VWywVIp
	 kyh8Ai7rod44K2BpkTti7zF8BlT9YJcJOyd/hodf7vlwS5K+sHOEDeAEtGRBCBA8fz8Mw
	 kCknYpFUZMle4H+8ALOnOw7E2fp8TqM1Geb56Z+Wmfdx8mD46vLh+Px0ixfRVuO4vFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XdyQwbK/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319B2606A325;
	Thu, 19 Nov 2026 04:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XdyQwbK/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACCF1F000C4;
	Thu, 19 Nov 2026 04:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062127;
	bh=W+6FEvOj3yU7bdU8yEHGoICuGD5hcTCllNtUzPVL4LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XdyQwbK/764wjb11quR48iv1a3Hnq5BU+RcDlMaa/ylUSQtx/6Jqx7pJSwY3MdSI5
	 kR4GOPG488LLAOkg++4HKt+hPPLE8O/tps4hadORRKb9DtWmJsXhqIMK8OapBBhu4L
	 kMgBf+hf/j5C4K9CY6wj7OeprbMrY3a+e85LObOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1799/1848] nvmet: make TCP sectype settable via configfs
Date: Wed, 18 Nov 2026 16:03:57 +0100
Message-ID: <20261118150034.574690283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 3f123494db725d899fdf990d894648bcc33cf7a3 ]

Add a new configfs attribute 'addr_tsas' to make the TCP sectype
settable via configfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 60385038754e ("nvmet: use the enabled transport when disabling a port")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 75 +++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index beef58d9d011e..299f7854acd83 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -154,6 +154,11 @@ static const struct nvmet_type_name_map nvmet_addr_treq[] = {
 	{ NVMF_TREQ_NOT_REQUIRED,	"not required" },
 };
 
+static inline u8 nvmet_port_disc_addr_treq_mask(struct nvmet_port *port)
+{
+	return (port->disc_addr.treq & ~NVME_TREQ_SECURE_CHANNEL_MASK);
+}
+
 static ssize_t nvmet_addr_treq_show(struct config_item *item, char *page)
 {
 	u8 treq = to_nvmet_port(item)->disc_addr.treq &
@@ -172,7 +177,7 @@ static ssize_t nvmet_addr_treq_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct nvmet_port *port = to_nvmet_port(item);
-	u8 treq = port->disc_addr.treq & ~NVME_TREQ_SECURE_CHANNEL_MASK;
+	u8 treq = nvmet_port_disc_addr_treq_mask(port);
 	int i;
 
 	if (nvmet_is_port_enabled(port, __func__))
@@ -299,6 +304,11 @@ static void nvmet_port_init_tsas_rdma(struct nvmet_port *port)
 	port->disc_addr.tsas.rdma.cms = NVMF_RDMA_CMS_RDMA_CM;
 }
 
+static void nvmet_port_init_tsas_tcp(struct nvmet_port *port, int sectype)
+{
+	port->disc_addr.tsas.tcp.sectype = sectype;
+}
+
 static ssize_t nvmet_addr_trtype_store(struct config_item *item,
 		const char *page, size_t count)
 {
@@ -321,11 +331,73 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
 	port->disc_addr.trtype = nvmet_transport[i].type;
 	if (port->disc_addr.trtype == NVMF_TRTYPE_RDMA)
 		nvmet_port_init_tsas_rdma(port);
+	else if (port->disc_addr.trtype == NVMF_TRTYPE_TCP)
+		nvmet_port_init_tsas_tcp(port, NVMF_TCP_SECTYPE_NONE);
 	return count;
 }
 
 CONFIGFS_ATTR(nvmet_, addr_trtype);
 
+static const struct nvmet_type_name_map nvmet_addr_tsas_tcp[] = {
+	{ NVMF_TCP_SECTYPE_NONE,	"none" },
+	{ NVMF_TCP_SECTYPE_TLS13,	"tls1.3" },
+};
+
+static const struct nvmet_type_name_map nvmet_addr_tsas_rdma[] = {
+	{ NVMF_RDMA_QPTYPE_CONNECTED,	"connected" },
+	{ NVMF_RDMA_QPTYPE_DATAGRAM,	"datagram"  },
+};
+
+static ssize_t nvmet_addr_tsas_show(struct config_item *item,
+		char *page)
+{
+	struct nvmet_port *port = to_nvmet_port(item);
+	int i;
+
+	if (port->disc_addr.trtype == NVMF_TRTYPE_TCP) {
+		for (i = 0; i < ARRAY_SIZE(nvmet_addr_tsas_tcp); i++) {
+			if (port->disc_addr.tsas.tcp.sectype == nvmet_addr_tsas_tcp[i].type)
+				return sprintf(page, "%s\n", nvmet_addr_tsas_tcp[i].name);
+		}
+	} else if (port->disc_addr.trtype == NVMF_TRTYPE_RDMA) {
+		for (i = 0; i < ARRAY_SIZE(nvmet_addr_tsas_rdma); i++) {
+			if (port->disc_addr.tsas.rdma.qptype == nvmet_addr_tsas_rdma[i].type)
+				return sprintf(page, "%s\n", nvmet_addr_tsas_rdma[i].name);
+		}
+	}
+	return sprintf(page, "reserved\n");
+}
+
+static ssize_t nvmet_addr_tsas_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_port *port = to_nvmet_port(item);
+	u8 sectype;
+	int i;
+
+	if (nvmet_is_port_enabled(port, __func__))
+		return -EACCES;
+
+	if (port->disc_addr.trtype != NVMF_TRTYPE_TCP)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(nvmet_addr_tsas_tcp); i++) {
+		if (sysfs_streq(page, nvmet_addr_tsas_tcp[i].name)) {
+			sectype = nvmet_addr_tsas_tcp[i].type;
+			goto found;
+		}
+	}
+
+	pr_err("Invalid value '%s' for tsas\n", page);
+	return -EINVAL;
+
+found:
+	nvmet_port_init_tsas_tcp(port, sectype);
+	return count;
+}
+
+CONFIGFS_ATTR(nvmet_, addr_tsas);
+
 /*
  * Namespace structures & file operation functions below
  */
@@ -1487,6 +1559,7 @@ static struct configfs_attribute *nvmet_port_attrs[] = {
 	&nvmet_attr_addr_traddr,
 	&nvmet_attr_addr_trsvcid,
 	&nvmet_attr_addr_trtype,
+	&nvmet_attr_addr_tsas,
 	&nvmet_attr_param_inline_data_size,
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 	&nvmet_attr_param_pi_enable,
-- 
2.53.0



