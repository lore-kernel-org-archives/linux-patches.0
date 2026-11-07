Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064303;
	b=sL6nZoUDTZwbFFPmAh5RuIqLQxZR7Wlclso1Ay+buhu+o4aLuKYrLmqFk1SP4csSsQdI
	 rg/GKVyDgjAOqGTE6MKxR3UrbzpyJhbQiHAvUibcFIipiij7NRsiZYfiIdpbUMT5Ogwm1
	 qaq/tBCtrxITw4A41EcBWlelWoe4K8+y2YEb2L7QOoUx4VKLgHauF0sg3fAQBZvdcuKAP
	 dLCcnqGf8slYyaRLXmiwBKRN6fSSoG7b9AT9uoXOgZm0CSqsxXYa/u1gNCA0LmZeFUZW+
	 sD50UN9ugq/q12akxcQERvB5tyExS7UjaKDwJZvf/oOiJAtmqhLQ0smSg95z9FIA/qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JVqJ4+Nt/2zruGkdMVaWHy4kJ9lHGKlktJ7U0Dpg0uE=;
	b=MaPOkTVGEwMPT6hlZFPNRiVm0W2DObQ3WtMmvTilVFiL2m8k9EHtltxJAMTb7l146MY9
	 Ud/oOMomKGB/NkYSOTsoCcSlRK9gZKtw19NyAIsCi99fzTv0B2S6wPCIm3FXsz7sL3Uoe
	 dc4uygnMJZQ7EgGDRHyO0uhE/9Qo32PP38qOEOHMpKnqBHpVZqHHGOhCoZXBTYw/Jb8uc
	 aUvjY/50s8y5pvvY5LN2VjTGAM4YiQqrIuyLghvwDxHBfAwb5pkHOAvnaUu7r/K7TJEdL
	 ELtoAXdFiJHJTr50EMhny2pZtT60KtxCfwQzKJatw4fiJ5paY5scyySwdNkrkijKZmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eCTAYClc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2CC606A9CC;
	Sat,  7 Nov 2026 15:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eCTAYClc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178EA1F0089F;
	Sat,  7 Nov 2026 15:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064303;
	bh=JVqJ4+Nt/2zruGkdMVaWHy4kJ9lHGKlktJ7U0Dpg0uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCTAYClcLv0noAwzsuLGPqgr82hFBkBZWHQgbYKix72/aI7DBR/ZJkt9xv0jz1XOc
	 RMBjVPGaHu2oWHpfae51jURKW15h0izw4krVW20pkpXol0LnW9VriYELuQqBXOA7Qf
	 d5LaXu0MJ2aPasuVp5bWl5NCN8QuAw/1WVOjiwEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0378/1257] pseries/plpks: validate input to plpks_signed_update_var()
Date: Sat,  7 Nov 2026 08:44:34 -0500
Message-ID: <20261107134949.990024870@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srish Srinivasan <ssrish@linux.ibm.com>

[ Upstream commit b59ff2d50b817eeec1259f357aae821c7834007f ]

plpks_signed_update_var() dereferences the supplied PLPKS variable pointer
without validating it. A NULL argument could therefore result in a NULL
pointer dereference.

Reject a NULL pointer argument with -EINVAL.

Fixes: 899d9b8fee66 ("powerpc/pseries: Implement signed update for PLPKS objects")
Cc: stable@vger.kernel.org # 6.3
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-4-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index ccf5765a907bf..e3ae2cd78247a 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -637,6 +637,9 @@ int plpks_signed_update_var(struct plpks_var *var, u64 flags)
 	u64 continuetoken = 0;
 	u64 timeout = 0;
 
+	if (!var)
+		return -EINVAL;
+
 	if (!var->data || var->datalen <= 0 || var->namelen > PLPKS_MAX_NAME_SIZE)
 		return -EINVAL;
 
-- 
2.53.0



