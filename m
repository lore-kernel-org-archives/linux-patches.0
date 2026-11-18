Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026719;
	b=4RqRYrcvSANrK3p1bXr2kKsnGuvwckmJ88ZgoBUoSI+t6UFSp6dKfErERAicAlxUvEF2
	 ZMMkFXT4y5f8SsDVKbEAtpjNzHo7NPnlH9jTK/ZhCQhGEW1MGZTOuRVmkPNlhj6WuJZ3N
	 WZOGLS9JdmVuCtsJDim4K9/lmNAhQZQDtywoQuPfTm4ITb+mCaQHALd6oXltdgZnftXGn
	 7o4W0/bAcDQOXwNNk03MBV+6/daBXTJmotP4swMnSkx2pOj+IEOD03hxPVCvvZCjq/g+M
	 nngpJJGAPMr1ls8UXYdgXGJPS1Ucg7h2LM24M5gJgUkUVPMi5mFL5H74hh8No0SiNtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oCJSGmx7P2R2qZfOaU06gFAgx0Ht2B0xZis6n9sVPyk=;
	b=Yver0VrvBJnKt2FLXVARp68OEpdYbaKjUqHuOP90k/K+Qd7dQFeLr0Do+v9f729BgiJm
	 WrZ4Hcp3mF3n5pzEHUYbRefe6+fXxcbMSCZNiglc9SCVjrFQM3qxqSTWrqJJXNnK/Iz3J
	 1oDmgUtjwjABaAJryZWpAT/AQFgwTA508u2VCo2z1LUg4TedQiVHxlQ+uvi90XbSs+y7X
	 +5waAkrGdzSuf5FzOP7N801/Z+XuN4wBsqPTnlAYzvHHoMh7vLTVwDpszml7dObf/w1Ni
	 GWRheXkzJFoF0Qy12zIVEm+kCzUMEMGF4OURI7r6syIGDQD1/NdSjnWNB56tAU63VIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssnD5JRo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E45606A320;
	Wed, 18 Nov 2026 18:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssnD5JRo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3934D1F000C4;
	Wed, 18 Nov 2026 18:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026719;
	bh=oCJSGmx7P2R2qZfOaU06gFAgx0Ht2B0xZis6n9sVPyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssnD5JRoJWirE6bpsEWhQ1LjNj9wt/5szPSEj9E5iNViqt1ypsJ+Y0Vre9n79mn9l
	 bkNrbHRG3/9+RoCuVhS6E0yu5bh/3xgp7PT3Lz0QzPhxVKHnWVvTQklgHo4wbQvkci
	 fpmvGUKZzpTPWEClu9YMl4WzjvDBc/rHvDctlSjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1535/2151] Bluetooth: MGMT: Fix pending state of instances added without HCI traffic
Date: Wed, 18 Nov 2026 15:54:30 +0100
Message-ID: <20261118150217.792325168@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5548fb51aa3cc24545029a286882d261a8e77d8a ]

When Add Advertising completes without HCI communication, e.g. when the
device is not powered or the instance is overridden by Global
Advertising, the instance is left marked as pending, so a subsequent
failure in add_adv_complete would remove it despite it having been
successfully added.

Fix this by clearing the pending state before completing the command.

Fixes: fffd38bca51c ("Bluetooth: mgmt/hci_core: multi-adv for add_advertising*()")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index d62d6dd91de77..c05acc157055a 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9039,6 +9039,12 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 	if (!hdev_is_powered(hdev) ||
 	    adv_overridden_by_global(hdev, adv) ||
 	    !schedule_instance) {
+		/* Instance has been accepted so it shall no longer be
+		 * considered pending, otherwise a later failure in
+		 * add_adv_complete would remove it.
+		 */
+		adv->pending = false;
+
 		rp.instance = cp->instance;
 		err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
 					MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
-- 
2.53.0



