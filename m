Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065451;
	b=ivtBLaqy4FQ1IUnGleD8bRZ1q6YYqGl6UTRUDZx1NJkaoGRwStz3FLM7Of/BJAlUCJOe
	 /194WgEIN1i3uPbAeBDf08B4JCTD69vLowMUbEiGxd8Bg3Pv8Tknesdr0L4VHltzIAo/J
	 E2gSV5dWI9sNBE8qlo2yrentrqsBwsBx4RvOtf/unaxP9oAEcxlOmCMBhDpnEf4mk+Dla
	 l9EkNMg6BF4xlGdq6N7XrpYnKmEfPlJpVg52Wpe9ttrZni+Xb/Y6fW4cMuRPwuhRsh5cU
	 STv77CQzWiglKnP+c6vxSovFxzB2PFHEKIM1D5asDjFTA31sVSLz3LFZZFL0lzZ7vHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2VLW6obPwDQUi2U5v8vEgxKN5ez37Zd0rCP2vz3w8P8=;
	b=vTCXzkaciSO5E54Y4fdv+5aDEsqkxPdpfMifjxJGy1XLDrIbLFtkUltEfz8anKDc2Y3X
	 WxM9rF13S8SmSP4zBo9rQb3HykmwF0uF5UswP/FtDAAc5IBCIxKBvnBJMusDyzuGuTAMf
	 YcVK9mCyMS03N0d2e5UuT8ofBsnCIxnkqu+h2QG0ZvqcvCY9ji2kT3B7ER61muqq3RBmd
	 rDTmVfG1J0FqTllOqx+MPb28I7l9IX5gsjsPVlfZglUhm0vtKTmrAojAC5fxgAMOWod3g
	 HjGqeG7zaBZ/FNXRX2tayI77jK6YaEwyRzp+8KBCNIL4Uwh61pjLGqh4Xm/B5itf82g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QYKxjTSx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0FE606A32C;
	Sat,  7 Nov 2026 15:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QYKxjTSx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA471F0089F;
	Sat,  7 Nov 2026 15:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065451;
	bh=2VLW6obPwDQUi2U5v8vEgxKN5ez37Zd0rCP2vz3w8P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QYKxjTSxemWm0dcbKTDjTWI3HcWljEQ8BDpSTn9RNg8qvQN/gc0hln00TCCq+Fvu4
	 TRhyfrK3gbl5rc43ozehQoJOtXoWkoukA7JNuuaRdT1lVJXCSLhHmUB8PhxAOO7+hU
	 W5tFjutG++UyMpmboiSTc1PJ+CiyFcSr+USmvTiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <1075151112@qq.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Neal Cardwell <ncardwell@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1153/1257] tcp: limit tcp_tso_rtt_log to a valid shift count
Date: Sat,  7 Nov 2026 08:57:29 -0500
Message-ID: <20261107135011.052532736@linuxfoundation.org>
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

From: Yingjie Wang <1075151112@qq.com>

[ Upstream commit 850a7225bc61cdfaf0c4b02ff341ae7cb54902f5 ]

tcp_tso_autosize() right-shifts the u32 returned by tcp_min_rtt() by
sysctl_tcp_tso_rtt_log. The sysctl uses proc_dou8vec_minmax() without
an upper bound, so it accepts values through 255. Values above 31 make
the shift undefined.

A process with CAP_NET_ADMIN in the target network namespace can set the
per-netns sysctl. With CONFIG_UBSAN_SHIFT=y, setting it to 32 and sending
TCP data over loopback triggers:

  UBSAN: shift-out-of-bounds in net/ipv4/tcp_output.c:2264:30
  shift exponent 32 is too large for 32-bit type 'unsigned int'
  Call Trace:
   __ubsan_handle_shift_out_of_bounds
   tcp_tso_segs
   tcp_write_xmit
   __tcp_push_pending_frames
   tcp_push
   tcp_sendmsg_locked

Limit the sysctl to 31, the largest valid shift count for a u32, and
document the accepted range. Writes of larger values now fail with
-EINVAL.

On a UBSAN/KASAN build of the net tree, values 0 and 31 remained
accepted, values 32 and 255 returned -EINVAL, and TCP traffic with the
valid boundary values produced no sanitizer diagnostics.

Fixes: 65466904b015 ("tcp: adjust TSO packet sizes based on min_rtt")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/tencent_31D2FFCCE76C50A695A1270151F825E90906@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.rst | 2 ++
 net/ipv4/sysctl_net_ipv4.c             | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 8edd2eb2ac49a..66a54c5106935 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1128,6 +1128,8 @@ tcp_tso_rtt_log - INTEGER
 
 	If you want to use the old autosizing, set this sysctl to 0.
 
+	Possible values are [0, 31], inclusive.
+
 	Default: 9  (2^9 = 512 usec)
 
 tcp_pacing_ss_ratio - INTEGER
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index e3760daa34706..bf193e7ec5168 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -26,6 +26,7 @@ static int ip_local_port_range_max[] = { 65535, 65535 };
 static int tcp_adv_win_scale_min = -31;
 static int tcp_adv_win_scale_max = 31;
 static int tcp_app_win_max = 31;
+static int tcp_tso_rtt_log_max = 31;
 static int tcp_min_snd_mss_min = TCP_MIN_SND_MSS;
 static int tcp_min_snd_mss_max = 65535;
 static int tcp_rto_max_max = TCP_RTO_MAX_SEC * MSEC_PER_SEC;
@@ -1406,6 +1407,7 @@ static const struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra2		= &tcp_tso_rtt_log_max,
 	},
 	{
 		.procname	= "tcp_min_rtt_wlen",
-- 
2.53.0



