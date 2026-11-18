Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016315;
	b=Kq1nqSn4dv24ANtjMf6Gpvb0fdm+7rXwk1V8JWT/KneMOgXv/AfMyPZ4QM9U99apAVPk
	 SUhH/dc5jkMX+JRel2ryNMnZwe7nWNyzz37D0EjCc6VSJC00aq3IRkjZVzMbpBn60NM7p
	 w5RWlepNlcQj70Stp12BnA1jzLya7eHbF3W462H4PiJo1xLswLJCehylAdnpP/lz+RbVg
	 9iCJ0jHjncPkgeMEJ1+73IH121cb/+YglaA0R3YkyWw3jcjeQk7tFRfcDWk7WHJl2+gBu
	 IFp/wz3eCYstmjU6xHJaOmo8xUAhXQrKXo7rMuGIBpE3JyUQcgyL5RSkzlSFr+aZFHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=iJBBQt8XecHNCd7DU5xeir3b/tA/tPN+TieyxmvhYQA=;
	b=Nj/oO4pVnXHtsWdnqugLhoNXHWGOyDqZnAiD4X7u9D8rgC0Ua/VXqnnbphFgT4Bcr5gi
	 /egDeXkvOr7rIKVTTTEEzkkGCiyNnbl49JX865XxVGgFrQOANP4V4DgSWtQQYG2hJFcL1
	 v+b/dglAaBp0Ztj/DSmfzo0RcwwHyhQdR+JxVNq9IsPfSVVP4n3QVJwYIrzurVBqehBM7
	 K3filUEqnVIHc+OUc6awGqk/PrHuTjmTdtHzrPfhdTaUuwx/F69t+bZvWLLc/fx2hwnDQ
	 tiR/n05wCce3/fjtzxQKdCvhHQO2kS97td86BoUSzUzm6P4YV4IwDMYiWP3iUZ+ltdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uMbMhX1R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3513160A2605;
	Wed, 18 Nov 2026 15:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uMbMhX1R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497B31F000C6;
	Wed, 18 Nov 2026 15:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016314;
	bh=iJBBQt8XecHNCd7DU5xeir3b/tA/tPN+TieyxmvhYQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uMbMhX1RxgD7cao6DxeAy3oIkUlZQ+bxykHhqdEvd8T3a2jHqpA05RpyapTOCcehu
	 q2VZJhMxyhA+RA5iMbYs4sMuwZSb6ETGc5NdgDMayS9Hk2zAcw54iDfWBrIubxIZrc
	 qFQDqBVA96+4LNrfSVnXf0aprBp9g5GvdUNoQUf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Marco Scardovi <scardracs@disroot.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0486/2651] platform/x86: asus-armoury: Prevent disabling dGPU when in use
Date: Wed, 18 Nov 2026 15:28:46 +0100
Message-ID: <20261118150305.276676494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Scardovi <scardracs@disroot.org>

[ Upstream commit b3f06a74fea6f1ddec192dfece8e52053d0b6c57 ]

Check ASUS_WMI_DEVID_DGPU_POWER_STATE before attempting to disable the
discrete GPU in dgpu_disable_current_value_store(). Return -EBUSY if the
dGPU is currently active and in use.

Fixes: f99eb098090e ("platform/x86: asus-armoury: move existing tunings to asus-armoury module")
Suggested-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
Link: https://patch.msgid.link/20260805183131.3075-4-scardracs@disroot.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-armoury.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/asus-armoury.c b/drivers/platform/x86/asus-armoury.c
index 93d9665717afa..cb7b526bbe71b 100644
--- a/drivers/platform/x86/asus-armoury.c
+++ b/drivers/platform/x86/asus-armoury.c
@@ -515,13 +515,25 @@ static ssize_t dgpu_disable_current_value_store(struct kobject *kobj,
 	if (err)
 		return err;
 
-	if (asus_armoury.gpu_mux_dev_id) {
-		err = armoury_get_devstate(NULL, &result, asus_armoury.gpu_mux_dev_id);
-		if (err)
-			return err;
-		if (!result && disable) {
-			pr_warn("Cannot disable dGPU when the MUX is in dGPU mode\n");
-			return -EBUSY;
+	if (disable) {
+		if (asus_armoury.gpu_mux_dev_id) {
+			err = armoury_get_devstate(NULL, &result, asus_armoury.gpu_mux_dev_id);
+			if (err)
+				return err;
+			if (!result) {
+				pr_warn("Cannot disable dGPU when the MUX is in dGPU mode\n");
+				return -EBUSY;
+			}
+		}
+
+		if (armoury_has_devstate(ASUS_WMI_DEVID_DGPU_POWER_STATE)) {
+			err = armoury_get_devstate(NULL, &result, ASUS_WMI_DEVID_DGPU_POWER_STATE);
+			if (err)
+				return err;
+			if (result) {
+				pr_warn("Cannot disable dGPU when it is in use\n");
+				return -EBUSY;
+			}
 		}
 	}
 
-- 
2.53.0



