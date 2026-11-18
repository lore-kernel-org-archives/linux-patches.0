Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042552;
	b=ROFnYPeV5B81fIW0R/ztSbH1osX/WFfMEcZQ3hdJNkDuAhVif8k3jVoXUmJkVHpfw3Cm
	 R+QBtiphPSlr0UdP6mBdr6J5lMzcxwRwzTqIdP/6YnlqHBZIGOwnMnB945/gKYOJgCMmN
	 Hv+/Zm2wF6sNyOniOREy1833dw3pXXS2WDERssR6jZHtEnUpgb4/lGy+hsxU4K3p2TWDz
	 fLiwErrn/uRew15TU4KiiKSCJbBG5oC7Tgb5wrKtz92/Va2IHx+ZJMOwZ3m9RArAHFBeV
	 gmvrAP9KwTfmRboayFsHavTQeNC0I3fDoP0p9noFW1l0PNeTGmwnKl5Vgk1RFDzRMag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iJKezz2drkO8hwm3NReWk1wlY+p54FTKW5ABfQvNc5E=;
	b=cssFWW4fbhAz6f+i1g7UP+/V0Dw7/yoPIdnUa9BOOCz2jcQm7prYgP97m5pOtjF7xcAy
	 KhGLjWtvbaVbAZex4t2r4WVYKeL1IqcgI2daCA8SyAGwtOb95y/UDKTnOS1gTa5drcuWz
	 5z6cu2NKCo7uLWsABaBOUpVOeqVYQzvNX5gkscw1+6ooSyzgl0eP7bJZ9Yi8mL+kc99tE
	 iAuTTdTNjCotGcKQosk95xKhsulZlqBBQXpBk17nFiJan38Mkw278GDjO1bVABK70aRA5
	 PnFtMnV0Pv8NXrAU8X+aiUQX64GtTeDDqrvEn7R4XBzKqwJlSCWniKN+TVE9F2No8tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LV78RQzT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDF0606A320;
	Wed, 18 Nov 2026 22:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LV78RQzT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629831F000C4;
	Wed, 18 Nov 2026 22:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042551;
	bh=iJKezz2drkO8hwm3NReWk1wlY+p54FTKW5ABfQvNc5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LV78RQzTB4B4NCPhYRK5OYKzQlwm9agU3a6oMfyWpapK56fNEDgUVSeikuiw0K5Xj
	 ytdBhXfthR9JhqS4f78pJNfTSlol7ag02UrTJa9U+ZwVBV8nD2AhmA/npJb7QF6zqA
	 W+dBItP+I1oMYl89BxWd5ch15hAH9ktS6I01F7OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3212/3318] nvmet: make TCP sectype settable via configfs
Date: Wed, 18 Nov 2026 16:03:54 +0100
Message-ID: <20261118150456.102646239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ff034f346bd6c..049c7f8226a15 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -160,6 +160,11 @@ static const struct nvmet_type_name_map nvmet_addr_treq[] = {
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
@@ -179,7 +184,7 @@ static ssize_t nvmet_addr_treq_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct nvmet_port *port = to_nvmet_port(item);
-	u8 treq = port->disc_addr.treq & ~NVME_TREQ_SECURE_CHANNEL_MASK;
+	u8 treq = nvmet_port_disc_addr_treq_mask(port);
 	int i;
 
 	if (nvmet_is_port_enabled(port, __func__))
@@ -304,6 +309,11 @@ static void nvmet_port_init_tsas_rdma(struct nvmet_port *port)
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
@@ -326,11 +336,73 @@ static ssize_t nvmet_addr_trtype_store(struct config_item *item,
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
@@ -1771,6 +1843,7 @@ static struct configfs_attribute *nvmet_port_attrs[] = {
 	&nvmet_attr_addr_traddr,
 	&nvmet_attr_addr_trsvcid,
 	&nvmet_attr_addr_trtype,
+	&nvmet_attr_addr_tsas,
 	&nvmet_attr_param_inline_data_size,
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 	&nvmet_attr_param_pi_enable,
-- 
2.53.0



