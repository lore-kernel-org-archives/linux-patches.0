Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052061;
	b=VW33tGz9Jsoq0TSuWoxnEx6XC0Giqk/hlVu8vAFIeh7/BSldSg3w4Hv6lmuuuXPqUsBh
	 4K7bnSP/Y3JaNOl1E66M8xTcHTW4hveEE7r6Hy4qw5sc1ZsRDi24G45DaADKy5UAKiAXk
	 mSqTlRivGOmDc51TnrlHmK4l0rck37rAk+HqLh/bjR/POsjgfhMeIhTrmlom2P1Wc8g1+
	 RPZ9u/0Bpa05TaMZsJAyYSXlvnhcxL1PgVT1+0gaf8WLyp3P4AUJGPdBUq1yAPl+Xubx/
	 s1vqA3+a9VqhWvI7krbzAIlxam+yvnPvksOPEkerhz7vVY1YkVoIOd/7y9vNfU1x3Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AuuX6jatQ/MRntzcDfuwq1xNv+7xb1xiJYSJYn4v664=;
	b=RRxG/Saj1FOYZjEQmCVeEZrz9//RvTJnmjMfh0oR5vOMPIEehUtV8g/LFMEFL4NCh+cN
	 dsOu0Mn2XSzuTpfMwDPFhbgdlRm1Zx98C3cYSjB0GxHm89CGe9OVFzcEZ3nRu6gQ4Z2T5
	 RNa+/wfQgj24n8BarEjg4FXnI+JZ7e6aFp4NwpkIA23VbAy/FPeTXUNNDDcfG/12HTXrF
	 C9S0B8L2KTqZb/nJ1iEM/ECGKp80v4HfQgCF11W5Y1SfIOCfSPNnWuOA8JKAusOL99zQb
	 tTnAvyxPifwEgwmUpDn7XXyakhnabbp15VFN7ay5dald7zzMve7u8nwE/MRDtyH8JKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZyU8yP/h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C08606A31C;
	Thu, 19 Nov 2026 01:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZyU8yP/h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D871F000C4;
	Thu, 19 Nov 2026 01:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052061;
	bh=AuuX6jatQ/MRntzcDfuwq1xNv+7xb1xiJYSJYn4v664=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZyU8yP/h1o2Fp8ZnZauselpwut7NC6OJAuXajBOO3d6PgGRvOQ4ckIqKqyTn6yPo0
	 MNYgf3uLqtBQq3bGgDpz/MRVHPMj/Ff+aj9IwKChLKUPrBW4/fN/o5BcBlj/VSX34u
	 g93iEL6NbiEp8s2zu8l2emuu3qeOj6JEpmo7S7ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0431/2214] media: microchip-isc: take a reference on the parsed endpoints
Date: Wed, 18 Nov 2026 15:35:07 +0100
Message-ID: <20261118150028.193949504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit f2eb2fd388bf3f1959556a326e797cacca341c86 ]

for_each_endpoint_of_node() drops the reference on the current node as
it advances. xisc_parse_dt() and isc_parse_dt() store the node in
subdev_entity->epn and release it later with of_node_put(), but never
took their own reference, so the stored pointer refers to an
already-released node. This underflows the refcount and can
use-after-free, reachable through the camera device tree overlay.

Take a reference with of_node_get() when storing the node, and drop it
in microchip_isc_subdev_cleanup() so the entities the bind loop never
reaches on an early exit do not leak it.

Fixes: c9aa973884a1 ("media: atmel: atmel-isc: add microchip-xisc driver")
Fixes: d6701f13bd07 ("media: atmel: Use v4l2_async_notifier_add_fwnode_remote_subdev")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: adapted error cleanup to existing explicit endpoint loops using break exits instead of goto err_cleanup ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isc-base.c    | 6 ++++++
 drivers/media/platform/atmel/atmel-sama5d2-isc.c | 5 ++++-
 drivers/media/platform/atmel/atmel-sama7g5-isc.c | 5 ++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc-base.c b/drivers/media/platform/atmel/atmel-isc-base.c
index f768be3c40595..eeaf91d80acd7 100644
--- a/drivers/media/platform/atmel/atmel-isc-base.c
+++ b/drivers/media/platform/atmel/atmel-isc-base.c
@@ -2219,6 +2219,12 @@ void isc_subdev_cleanup(struct isc_device *isc)
 	list_for_each_entry(subdev_entity, &isc->subdev_entities, list) {
 		v4l2_async_notifier_unregister(&subdev_entity->notifier);
 		v4l2_async_notifier_cleanup(&subdev_entity->notifier);
+		/*
+		 * Release the endpoint reference taken while parsing. It is
+		 * NULL for entities the bind loop already consumed, so this
+		 * only drops the ones left over on an early exit.
+		 */
+		of_node_put(subdev_entity->epn);
 	}
 
 	INIT_LIST_HEAD(&isc->subdev_entities);
diff --git a/drivers/media/platform/atmel/atmel-sama5d2-isc.c b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
index 7421bc51709c4..cf96d40828ab5 100644
--- a/drivers/media/platform/atmel/atmel-sama5d2-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
@@ -354,7 +354,7 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 			ret = -ENOMEM;
 			break;
 		}
-		subdev_entity->epn = epn;
+		subdev_entity->epn = of_node_get(epn);
 
 		flags = v4l2_epn.bus.parallel.flags;
 
@@ -375,6 +375,9 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 	}
 	of_node_put(epn);
 
+	list_for_each_entry(subdev_entity, &isc->subdev_entities, list)
+		of_node_put(subdev_entity->epn);
+
 	return ret;
 }
 
diff --git a/drivers/media/platform/atmel/atmel-sama7g5-isc.c b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
index a4defc30cf412..3183ab2345c8b 100644
--- a/drivers/media/platform/atmel/atmel-sama7g5-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
@@ -344,7 +344,7 @@ static int xisc_parse_dt(struct device *dev, struct isc_device *isc)
 			ret = -ENOMEM;
 			break;
 		}
-		subdev_entity->epn = epn;
+		subdev_entity->epn = of_node_get(epn);
 
 		flags = v4l2_epn.bus.parallel.flags;
 
@@ -368,6 +368,9 @@ static int xisc_parse_dt(struct device *dev, struct isc_device *isc)
 	}
 	of_node_put(epn);
 
+	list_for_each_entry(subdev_entity, &isc->subdev_entities, list)
+		of_node_put(subdev_entity->epn);
+
 	return ret;
 }
 
-- 
2.53.0



