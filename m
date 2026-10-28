Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208545;
	b=FFHbSMM9Va9PgakWRhOesF0j/UmkERZw+04aYfycR1W72528awWOU0ctWZPwnfcgqEDf
	 pgQcfdA7D6kykuWvEhCI/jwfWGvbOXMpdLVBARrq5ZhRJ8xx9AGvYoVs4YslPNoGuVoaj
	 Fl4XWs4qhFKEuQgsgTh/dJqfycCymdY2mPkWiO2ktSyP8C+jh/F8vo+Uqah2QSgzNmDEp
	 sIcNMSFF5k368HcO5s19sYPflDUylwx40tyr5sJug/pK/S81SHfDARRrGD78JcQU1QGPt
	 tsQNfiPFQo9Wxsm8O4hBGxw+aV/tphkZowScBpLx6+0B2TK7+6pKszB70rXnlCDiCvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yuf6LVHrVY9rix9dDs/oz8Cu2wXC85mjaOgf+ZO/pfM=;
	b=IcR0CvvUQIQiWD9XxhShuyYFtSf0EpkqMfbbDG0rKhxe7bJDnFXtkqAuXywIAt4QrclN
	 xQXsp7eYcSZ+/eEwj9i2poKtGZjV/aNR3qNBKoxfNVu8jPa28/CyxlcaPPdiR0d7y62X2
	 6pI5myHacxS2zR4eOTAtKOCVSymYHpnjruYqzUAGLvd4xzEtOPLm18BbmfR9KtXbuckLg
	 Z9IQNbVcknf3SOpwpQkWSTufBmzEsWOM2nZcE93RQE+JshNh2cnNyrLPXK2PKnLXrzy6T
	 Hj4HrlC2lGOhNYkciPmY2K30jYP4YggXEYMJcy/Q+yA/iQEN96KUNpEzSUgyGo4JmNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6L8uelP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF2C606A31E;
	Wed, 28 Oct 2026 17:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6L8uelP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7A31F01825;
	Wed, 28 Oct 2026 17:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208545;
	bh=yuf6LVHrVY9rix9dDs/oz8Cu2wXC85mjaOgf+ZO/pfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6L8uelPXEqyx22kfC9gPkaJFbt+Rdd4x78eIpCyIzGuGKsZUM1z2KkWD2trRyFdR
	 dkltGBAgheMdGjbmkrchnHgoWso31VM4TA5UPsFYP9tsP8zDsl0o5VwB7bKP4fZygF
	 PJyMSa/Hb0HlIiNXvE+RiiRt2X7uXCLdSfsuL7Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/516] of/overlay: dont leak fragment references when changeset init fails
Date: Wed, 28 Oct 2026 17:55:10 +0100
Message-ID: <20261028170007.249238493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

[ Upstream commit 1d62f0f2bc7edb12ed09f71203df0e47fa4efca4 ]

init_overlay_changeset() stores the number of initialized fragments
in ovcs->count only on full success. When find_target() or the
__symbols__ lookup fails partway through, the target and overlay
references taken for the fragments initialized so far are never
dropped: free_overlay_changeset() bounds its cleanup loop by
ovcs->count, which is still 0.

Store the running count on the error path so free_overlay_changeset()
puts whatever was set up. The store is guarded by ovcs->fragments
because on the allocation-failure path cnt still holds the counting
pass total while there is no fragments array; everywhere else cnt
only counts fully-initialized fragments.

Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/20260805204009.CF3891F000E9@smtp.kernel.org
Fixes: 61b4de4e0b38 ("of: overlay: minor restructuring")
Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://patch.msgid.link/20260831-nh-of-alias-overlay-v7-6-02754604805a@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index eea2114266e91..67063a516070f 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -841,6 +841,10 @@ static int init_overlay_changeset(struct overlay_changeset *ovcs,
 
 	pr_err("%s() failed, ret = %d\n", __func__, ret);
 
+	/* let free_overlay_changeset() put the fragments set up so far */
+	if (ovcs->fragments)
+		ovcs->count = cnt;
+
 	return ret;
 }
 
-- 
2.53.0



