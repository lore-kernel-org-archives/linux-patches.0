Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212553;
	b=siwNVCA322I2Fne0Wm0ENWqrBadzY5zrVUKg3c5J5vqAUXGlyOAcuhsdXIgWYJoqsLIO
	 y6sJCpUZYVt5a+oCC0G1m6eGJ8FLMGyHvFYllixhv9vIhTxJ6P/UqEGZLHykL/O6iemNi
	 jSHmS87ufm70uCc0z6MN/n8m0moaYRmXB11rKtf/ZQttSj0bDnpFWa9mCiV/dQUzH812p
	 LqtUivxHxxoo+esaa1sxkFJgyXEQm6Wsp6q4+XGrwfO7RSsioMB5jCPHEkkUePUy2TCdw
	 2yZC2s5NOOFo1wuIodl7NHdTatoB8g68+Vc69+jscJC/6lqn/rpD7iibXIFt8ifFOFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KfrpTfbyA2hkO4+cvLWcs0tlz+O7KAkXQYqHssXrIXo=;
	b=U4DCQijtJjFo5GqOGX/aG853gmtS/67imiTsLzxvMtP4sHDaTefrabXzjiYyCdBN5HwN
	 AfiBfZhMbI5k/1/6GVNQEkMZAJjOPBDkkrCLfuQLP1AE8vPo8qp3fjFiFZ6dAhpXJav59
	 8/FpaP1EBzTjCTxgCcb3sPYQdgbtig6LR3hTiy71meGJHzpsVXkZ3euEKCn5PJcCrtsp9
	 fznuAVnXka9vcMEdwshQeB3PibTH+e0rR2G/sJb1TbbAwJuJ8uYKa2RfC2RPgUB6tXk/g
	 ASKvz/z1VhT+aCQF9I6kGv72okpCYP4jaoTmsNdBGzy9pB0PCtpSxJG7geP0qovPhDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOGAkwaW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4308606A31A;
	Wed, 28 Oct 2026 18:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOGAkwaW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29A21F01825;
	Wed, 28 Oct 2026 18:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212552;
	bh=KfrpTfbyA2hkO4+cvLWcs0tlz+O7KAkXQYqHssXrIXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOGAkwaW11hcp6JNw6DWHiVSzwM7qAy6h3vYMre9vqPydTxJb3/wEnDGfVC21eQxa
	 8O7Ks97LaKX2suZ8z14pPIZ2Yu8C5S0Dj8hlvucYZbmPoYWYsOxFbDL47RsndmX2FE
	 i+3Yb7M+3320ZCYrImR2f+MRrawvrXkdAKYfElgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0193/1887] drm/i915/hdcp: Add encoder check in hdcp2_get_capability
Date: Wed, 28 Oct 2026 17:38:09 +0100
Message-ID: <20261028170503.628328253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit d34f4f058edf1235c103ca9c921dc54820d14d40 ]

Add encoder check in intel_hdcp2_get_capability to avoid
null pointer error.

[ Backport to 6.1.y: upstream adds the check in the DP shim's
  intel_dp_hdcp2_get_capability(), which does not exist here. This tree
  predates the intel_connector conversion of the shims: its
  intel_dp_hdcp2_capable() takes a digital port, and the
  intel_attached_dig_port() lookup is still done in the common
  intel_hdcp2_capable() helper. Put the same encoder guard there, before
  that lookup, and return false through the bool API when no encoder is
  attached. ]

Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240722064451.3610512-3-suraj.kandpal@intel.com
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index 507721c94f2fd..d31c1f1f0e507 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -208,11 +208,16 @@ bool intel_hdcp_capable(struct intel_connector *connector)
 /* Is HDCP2.2 capable on Platform and Sink */
 bool intel_hdcp2_capable(struct intel_connector *connector)
 {
-	struct intel_digital_port *dig_port = intel_attached_dig_port(connector);
+	struct intel_digital_port *dig_port;
 	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
 	struct intel_hdcp *hdcp = &connector->hdcp;
 	bool capable = false;
 
+	if (!intel_attached_encoder(connector))
+		return capable;
+
+	dig_port = intel_attached_dig_port(connector);
+
 	/* I915 support for HDCP2.2 */
 	if (!hdcp->hdcp2_supported)
 		return false;
-- 
2.53.0



