Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063049;
	b=1TV0EjPmmkO648R6Xm6Y16vTwm1Y+4jVwZqRg34oVj56rPaPOrKwSsoaWhVydacEWBoF
	 GMNqs+FqLa0YsN7oYC+DTLnGU/iFDhWnT+koAhBIEI+gFNIPV+yRKnzx7HsoCjF17C1uz
	 /VpjxUVpTLsKn9Ipcda3PvL48gPEuEmGUNXwtdT5/PcI/1yyEIAlSDIe09HmtXcqBjc99
	 kmrQry0HOM37ABKHrDAOCoPxotgsI1B4lFSVerpsPoFzWIUmfbDxywI8xge6TF50xxtmh
	 fQSVKlcGZMBE6QzEPd4CGfhXx9gssTyAVnC5LKm0d1sE9ZeUs5w4NDTqEqRauI/4WgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+nDOL11drOn8MqNE9xvTk2Ww4hGnikW6YPyQk8eqUb8=;
	b=jkhUfYF3JJGmbbloRN8OB4m566ByqrAs1ekfBsbkoha1FwNZPjZW/vb3uKrBz5ROlquI
	 X4ta3z8BmLgpq9UTw94xcezqZkJE2wYKK0a0eKbaK4m3czhlpc/Y+DTLeR8WOJT8GovJQ
	 yQldrA4mV5GacHSuGzf4WfkIzso6qa4rSNnwLcAUwGmQe2dRcYsFDQQSEcZlyDGbd4Csr
	 qimz3qyamKznumLkwWF2X+JU0dhgWVvFGwnIwTzcrDVKEG1Unx+gNmWxWG1hY6TRIoj/h
	 2mcKOD6dEm+q2vruaneSZmJtk9vrQXhQssLsKLKOTwjFca23TP57WpVAMZh0p1bXSJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lXDWa7kv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A138606D801;
	Sat,  7 Nov 2026 14:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lXDWa7kv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9D81F0089F;
	Sat,  7 Nov 2026 14:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063049;
	bh=+nDOL11drOn8MqNE9xvTk2Ww4hGnikW6YPyQk8eqUb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lXDWa7kvwmAsRJhj88LMdfHB9AQFLBMlhQtfUTtSGSuhHfF8JDJgYVXLP9QHr8+80
	 OHx1ibsKZSK4lW0WgR66mF3dgJQhJszVk1+UfNyr9yfTugVwPA+Wo9y9uzwF8+AW54
	 ipkwor0nXTCJvggftQ18bSvA0kXX6F+F91OxX71Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 294/869] pseries/plpks: validate input to plpks_signed_update_var()
Date: Sat,  7 Nov 2026 08:49:36 -0500
Message-ID: <20261107134902.003472954@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 1ea3ef0a36254..3686d66277262 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -434,6 +434,9 @@ int plpks_signed_update_var(struct plpks_var *var, u64 flags)
 	u64 continuetoken = 0;
 	u64 timeout = 0;
 
+	if (!var)
+		return -EINVAL;
+
 	if (!var->data || var->datalen <= 0 || var->namelen > PLPKS_MAX_NAME_SIZE)
 		return -EINVAL;
 
-- 
2.53.0



