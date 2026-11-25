Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617816;
	b=L3loQyNLftRlEAeKlVjqeFyxZGqfaC8X4L8slbkRJ5beOZJk4c2hHgD6VWUfkoZ2gF8P
	 HsPbIq6JAMXUqx4vMuA84FER1kQlooMcjuOyNcUSQaQI7WJK7/p+1o0P7bMyOFntDKILk
	 mMtlye/7xDQgoVJtfy8Pi1Yq3r1O3dzd1WCY+vac+NJMj47F2Qpjazia5cLTWZhr6qEz0
	 2QtzNxVpZrARNkyffaI2MqFyE24wx2a+Ir8Uy56RwZ6FQnXQ5QtE/OxZ4A3ziUUdaQ02x
	 1s7vr6NXXyjmmMTCX0kOcs8Vl93fWSDIznsEXM1xgcRJOaEuavZIUaf+BSR22y5pJpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rXKUe/776pLa2XqlMnUOQZGH5iQA0H21qQRrXWNpm2k=;
	b=shD+DSmN8nkqr8iXkQ6YqbvWK3EaEbrdjwDYFEh+LO5Yv2C7CDdE6dSvwWN2BxDzEAYw
	 Bc6RTDw4f8RQXQXkxdj1kOBFFLWgidMexmlfzf0wgrjBmnyCIibd26fRxUrR4vDIBrMLU
	 Y3bGdEM13rLgDJEZgMjI0byvKTR04V4Aeh4KnzJZwKrWuRPFHMZ4adU2l68NKQ3bXqxT/
	 p9GSJRYjzhZLK9FOxB+2EOYtYjkg4nR/uPzmkoY3Sb99S4oFK3yUSocaef0UIjleO0YLy
	 ej2HEp1Q9yVg4+qPaCI6E+OPxfY5ovt24wIHY0ytfU9UxchKEYG5aVwG5pT5rE7U3eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kGykqDLD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D6E606A321;
	Wed, 25 Nov 2026 14:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kGykqDLD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF7C1F000C6;
	Wed, 25 Nov 2026 14:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617815;
	bh=rXKUe/776pLa2XqlMnUOQZGH5iQA0H21qQRrXWNpm2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kGykqDLDElQZ6RLkqH8mP+dZ/aQIu9fH1MNKOEHwzuAfJaZ3VnnqsJU2rG5cVKbYi
	 2efNHYzNQSKRkRMX6CsoYEyWRb/t/PBryvUm9NY7TZii9NZBlOE9qlWbgzT6Y7CgqE
	 keAIfCWYv9KPODTyPmBmLSfyrkwAXEr8hzytem4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	James Hilliard <james.hilliard1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0084/1005] ptp: vclock: preserve missing hardware timestamps
Date: Wed, 25 Nov 2026 15:23:42 +0100
Message-ID: <20261125143823.708757813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit 63787dfd1b5ae720cc30dab5e66c8e4d81ff7391 ]

Socket timestamp delivery converts hardware timestamps to a bound
virtual clock before checking whether a hardware timestamp is present.
A zero timestamp means that the packet has no hardware timestamp, but
timecounter_cyc2time() can turn that zero into a nonzero virtual time.
The socket then reports a hardware timestamp which was never supplied.

Return zero without conversion when the input timestamp is absent.
This also covers skb_get_tx_timestamp(), which checks for an absent
timestamp after the same conversion.

This was identified during review of virtual clock sampling changes.

Fixes: d7c088265588 ("net: socket: support hardware timestamp conversion to PHC bound")
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Link: https://patch.msgid.link/20261026-ptp-vclock-sampling-v6-5-e705612541f1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_vclock.c         | 2 ++
 include/linux/ptp_clock_kernel.h | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 679ae40916f7e..e9cf4da3ed8a4 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -326,6 +326,8 @@ ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
 	u64 ns;
 
 	ns = ktime_to_ns(*hwtstamp);
+	if (!ns)
+		return 0;
 
 	srcu_idx = srcu_read_lock(&vclock_srcu);
 
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 36a27a9105958..56f6ab1855d38 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -496,7 +496,7 @@ int ptp_get_vclocks_index(int pclock_index, int **vclock_index);
  * @hwtstamp:     timestamp
  * @vclock_index: phc index of ptp vclock.
  *
- * Returns: converted timestamp, or 0 on error.
+ * Returns: converted timestamp, or 0 if @hwtstamp is zero or on error.
  */
 ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index);
 #else
-- 
2.53.0



