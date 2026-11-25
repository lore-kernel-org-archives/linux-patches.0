Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619846;
	b=q94O1gEcT/VSdMU6RSRqHN9bdowZOTVmmWMM+O8RolYXX0nZn4ITdINbwvj/gkBndh73
	 5MhXGE0fAUcj2OLh0oYY2MQBxjSu+pkLGw41oe9IcTSbyfZcUq/X5E7r+HdxZhfEjdRs0
	 XCdvoMtJUSmlUa/d0tJ9kPMVzmidvhNiCA5dNXcqV3ce7jn+S8Cv0H/cikUmcg/e0UkKh
	 bTxn+UPBoM7xcbD4cPskQtlweVvEcA0r0Gs1h6V+S/5C4m/hkkYOezRtePwW/6yHsdcCh
	 x+eneNPuCtNrFuFtT/Ph9rcJFTsGDF3D4L4iIOOi/AWY2g1xF9b0KNMCLyNCrWWj/kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=igNpSNNt9+b3aXSWmkggvEJs8/BKJ0rNedCkhTMqx6M=;
	b=3ag2XZLvLS5815h04Yd3kM/Rf1E64ba6EmKP4TnBTQGA+cZGPcF/HXO7xb6VeTgi6tIA
	 s9htovo9mygztgWH2Md/Dftbxs4r0v93ydmO7pH/VEkoShj9KlxzTGj2A5RlmuyuQW3+X
	 wtOwjAc5RJHVcDQtgv2x28Gl+6giFjoRIh/6issuW0MWyic6eRW80gVxqEFt6Hbvlcmuh
	 lx63Xc8dbxr+WW1TCf2iBEFUVEmmZtwx/2aLiNmV46yHVJr3ly/1L4Vq9K5ZM0VE4ZZyN
	 CrTKf+nGmlQKYxiPZNM3/VFPqAsUe8Ohpfakspfb1K0ux8fTWl9SUUdvNDrpWeUUEVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=exPNQqZH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70306606A323;
	Wed, 25 Nov 2026 15:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=exPNQqZH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18F11F000C0;
	Wed, 25 Nov 2026 15:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619846;
	bh=igNpSNNt9+b3aXSWmkggvEJs8/BKJ0rNedCkhTMqx6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exPNQqZHKh58OUUoEEDZrRyXIZZY1piqE37eSb1V6AGhmDSNNc2QzWamiRT6+QwWg
	 jq3Wd10VNDiO+qnCApx0QSzMcXB3i+XXCmC+geCgWuulj5czuScEHlgv7KF0VrbqPt
	 RLEe9LY+9JGDCb3rJnym/+oRxPwv3keyJhid9iK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.3 0725/1005] timekeeping: Refresh auxiliary base before offset validation
Date: Wed, 25 Nov 2026 15:34:23 +0100
Message-ID: <20261125143838.744707314@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

commit c1b96ba87e3caaa701d6dba254e58db7cc3c99be upstream.

timekeeping_forward_now() can advance an auxiliary timekeeper across a
second boundary without refreshing tkr_mono.base. The negative-time
check in __timekeeping_inject_offset() then uses the stale base and
rejects valid ADJ_SETOFFSET adjustments with -EINVAL.

Refresh the derived timekeeper data before calculating the current
auxiliary time, as aux_clock_set() already does.

On 7.4-rc1, a valid negative adjustment fails at the first second
rollover. The patched kernel accepts all 12 tested rollover adjustments
and continues to reject invalid negative offsets.

Fixes: 2c8aea59c206 ("timekeeping: Add auxiliary clock support to __timekeeping_inject_offset()")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261103090605.1292660-1-thnkslprpt@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1776,6 +1776,7 @@ static int __timekeeping_inject_offset(s
 		struct tk_read_base *tkr_mono = &tks->tkr_mono;
 		ktime_t now, offs;
 
+		tk_update_ktime_data(tks);
 		/* Get the current time */
 		now = ktime_add_ns(tkr_mono->base, timekeeping_get_ns(tkr_mono));
 		/* Add the relative offset change */


