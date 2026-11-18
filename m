Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021132;
	b=l3o8t/3lCrOuAJHiglcxQcZUyKnTQke+PFlyewY09KwTgegJdAiV2WRjgG0kpIyzyzTK
	 8VoKNJKw82UH9n/bGmxlHWq1sxxj7pLaxH59Ofl/NnzNX8CvN8oGADc0/r2wbY0Q5dva/
	 Utjr2lyFN1Dcb+DXwQSshzT76CJAc7Wv0rRi3Qjb5L7H06yU1133kqtE6bqcsAnY2JPO9
	 ykchmWPIkFzTHhUFAo7k8xFLHCfj/Djlu8jp391R+6FTY1XBf4p/mzjr9vOxTBBm4ylAK
	 HnvnsZmb/4g5paHUoLpO56Nrx5h+JXwBLhQJkcrOkHXP2yTN/tXt8tm1YMA96RGuAgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ofhnm52J90jx+8WyhC1LAGzvVyMU1UXSDqlJlO75O38=;
	b=4aa7+EWrfDWH/unLAQFuexieDGNPxTYkMPLPYy6MBmLXJQNHKlR4/gQcrteHkphfw/Se
	 TrWkjnTUPqPWeh5u1nSDQo1BNm4619Twb0tYxwVqU7S0j53zj3AfMdVkIFzOdfjItkxKo
	 vy/X82MizICSQnyJlyq6OZqZ8RwPOAcWcXJLs3No/HcO99fBsvjoySnQkV0MYTph/rS2a
	 0x+435DOs3grL+3gMJpjkk0TaZsFfOeea+RouPkv881TyaH5akhfSCDuMgVGfis6Y+VkD
	 b8kRXmeFmFooiFqjj7hkT6PBODPtwT91nVfVOCmcqW1dtA/oaz48ZLIEy9NYgUUG05A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IPcSCFkA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5423A606A330;
	Wed, 18 Nov 2026 16:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IPcSCFkA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA94F1F000C4;
	Wed, 18 Nov 2026 16:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021132;
	bh=ofhnm52J90jx+8WyhC1LAGzvVyMU1UXSDqlJlO75O38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IPcSCFkAp9iU2sy0+MnM78BpvTJNwvGFilEyPX9Lv0Jl/al0jcNxvfLg2XlvMMKeG
	 oOQrw/2h538Pv1C7dxo1pqoS6u2jKjCMPQ3IR2XQ1CJ28UeWYUZkzJD3H0gUJRX3lh
	 Cx5xGBYB8yCZ0wXq2ERPX3eDz+U6LR6YdN+eMN5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2199/2651] selftests: tc-testing: use $IP in hfsc test 8c39 setup
Date: Wed, 18 Nov 2026 15:57:19 +0100
Message-ID: <20261118150404.872182095@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit b6ef0d965fe8ce0ee4b4dcb58b3511f83003e42d ]

Test 8c39 brings up lo with a bare "ip" command. nsPlugin runs it as
"$IP netns exec <ns> ip ...", and as tdc runs commands with an empty
environment, "ip netns exec" searches only the default execvp() path
(/bin:/usr/bin). On systems that install ip only in /sbin, like Fedora,
the setup fails:

  # ./tdc.py -e 8c39
  Test 8c39: HFSC classify walk still reaches leaf after lateral drift
  -----> prepare stage *** Could not execute: "ip link set lo up"
  -----> prepare stage *** Error message: "exec of "ip" failed: No such file or directory

Use $IP like all other tdc tests do.

Fixes: 1e24c4f2ee44 ("selftests: tc-testing: add a lateral-drift hfsc classify-walk test")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261014121414.2373985-1-ivecera@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/tc-testing/tc-tests/qdiscs/hfsc.json | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/hfsc.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/hfsc.json
index 4f6bbb8b57f93..557730eef0559 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/hfsc.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/hfsc.json
@@ -181,7 +181,7 @@
             "requires": "nsPlugin"
         },
         "setup": [
-            "ip link set lo up",
+            "$IP link set lo up",
             "$TC qdisc add dev lo handle 1: root hfsc default 30",
             "$TC class add dev lo parent 1: classid 1:1 hfsc rt m2 100kbit",
             "$TC class add dev lo parent 1:1 classid 1:10 hfsc rt m2 50kbit",
-- 
2.53.0



