Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058811;
	b=QawXGoyJkIyyFIbV4h0FwVgVUkoqBOiZN6b2CVJBnBX/rbgfgvmcpcEhrtR0Qijp8aqi
	 8QbtZ8QHqFhnst71ALLWu6/jBD1KrQP3P0HpXTtVCP5rfUe8ozoLaSiCnlH330xrN9DzT
	 ZEyZN5uXSAqyOnTnqZdbJ1at1GhnJyKc89sR76PPyg2z+x/ILdFg0bBY9RQ2/SZYhY0Et
	 uM6TmyHuuenSpe7MMLtgge1Cf/LUoUI5I0QLRcgiKemX1YrDW8h4vZ6a680rBvzBVUuj0
	 CQULhrjHhC7haA7VBUMTFQ5cWgIe4YrFsWR8yW2ngrjvwy7cF6yDs7gBKgotYq6RVBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o0NoBpYQ8kg+WYNaSkwbRJQ6VhXVF4rmIq8EtLHaUqE=;
	b=P/QIc5G8NHrdpt/O6DtvqRlJgV7ratRhS8JxBenPNHGuYSOluL3oQ/2j/2iCzLQ3Dvy9
	 onHHTA998+cHqRK0pGAmN0oQ5a3ExBd7Y/rq4U/wdBUGUNN7YeMk3oRFLYBI2glJKaR+k
	 m3qj7SyZhjQ2nMNt+QbJWDah0MDbgOqNmptpPSfiLwTl+cAxaKWyX8rHET4JC6RHSRURg
	 f4l0vRCDGG9vc2kknbsG2y/SFad9LsOqTGimkd6lFJmOpLopom0tVwszSI6yltYncEK+V
	 RQKMQ4Qky8TJ7RWRk0hig+2hQDwWNzzt0WcdHJX4LEenv5FmoGJWpErLUjqP2qzEEUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q1cNcG7t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535BB606A32C;
	Thu, 19 Nov 2026 03:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q1cNcG7t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E85A1F000C4;
	Thu, 19 Nov 2026 03:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058810;
	bh=o0NoBpYQ8kg+WYNaSkwbRJQ6VhXVF4rmIq8EtLHaUqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q1cNcG7tzF+/1sTE/DkKCBrkkNKqfQAMp0M3Gx1u/mj6cu5qZykyo5ltmti9KEOtT
	 sp4IHctxMxUVRpg/zENk6ZtewXVttUCAMza/DdE8dcqJnuNTgPyk+Kt+2y/CC+d9Nf
	 kC62dT5Fxp77fnvJJuWY+Mn+x1damzh1D2FnTlJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0577/1848] libceph: Fix unsafe decode in ceph_redirect_decode()
Date: Wed, 18 Nov 2026 15:43:35 +0100
Message-ID: <20261118145939.312372335@linuxfoundation.org>
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

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

[ Upstream commit 0405670e50f213594366ab7eddc07002bd7f84c0 ]

ceph_redirect_decode handles unchecked data received over the network
from an OSD. Currently, there is only a bounds check covering the first
three decode operations. After decoding the first len field from the
message, the only remaining check ensures there is enough buffer space
to hold len bytes. However, there is no guarantee that this value is
large enough to hold the subsequently decoded fields. The decoding of
the second len field is missing an explicit bounds check. Consequently,
a corrupted message can trigger an out-of-bounds read.

This patch fixes the issue by switching the decoding from
ceph_decode_32() to the bounds-checked version ceph_decode_32_safe().

Cc: stable@vger.kernel.org
Fixes: 205ee1187a67 ("libceph: follow redirect replies from osds")
Assisted-by: Cursor
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osd_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 819d29dba0a08..ae530f1248d89 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3575,7 +3575,7 @@ static int ceph_redirect_decode(void **p, void *end,
 	if (ret)
 		goto out;
 
-	len = ceph_decode_32(p);
+	ceph_decode_32_safe(p, end, len, e_inval);
 	if (len > 0) {
 		pr_warn("ceph_request_redirect::object_name is set\n");
 		goto e_inval;
-- 
2.53.0



