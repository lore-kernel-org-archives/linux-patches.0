Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795108546;
	b=rbIqUhKjsCaGd7PYwnRcXB8D8EMIQnRYC/jo7dQ+t4/pwdWupixMusfvt9+0k2ZZaWgj
	 He7/ZFs/4k5EJ/HQanok1ihUTtxxWwxD3WIP5z2ryarV8ird1x8acq9g9RML9ziqGZa+3
	 3wPmB7bNEfUq0vjBYjSglMTPvO2DrZL3n3IbXki+6cCko4JiNlP+H+t+4URjOFCsReBla
	 mt6GiPwOf2clb4yn9KvX2WrtTgUKFJInH6zV9z3nfYub8Nv6UMFbXjS4IkdraQR3nRsyt
	 NqQMFR6aUWtYeJZdTQ9PrhfaNJL1r6xsnULUfKmFYAs9nyqzLCY/qY2fEdFmm026CBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795108546;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=gG6SYRci2tonbzUE1w7siSj6Ls8OXf6NC7m+gjOpDgc=;
	b=ump2qSrKZ0EpwTPEp0fAkSTY30HkjY04t5Ym2zDKG8htJ84OhVRAgKZISIz1HrET3Vdl
	 UlnthI2Ih3xcQZhBo/4OhQOrajKfcqf5e3c2QPv52XzMQK6TFlsMs0XQZVmSlh3xzWbyK
	 ShzRb3tHHZ+weyHC87F+2EB+Myqq+ttCEpYYUFF7wv66uhDxH55j/vR3muLH2rV1zOx2k
	 YEu4SoEikfaxLpwXB7vRtP9GIrvJY+xp9+LpetR7/FyBLYhIh4n8vMcyOnJj2uBJgiOAB
	 wJhmuwYT27eDdT9Vu/Z6EhX7fz6yb8rDhHtiUPfKzGfvSF/+IbvWmpgZJvOIYVWsy0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pobox.com;
	spf=pass smtp.mailfrom=pobox.com;
	dkim=pass header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=eoXscN5N;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b="F/E61bVD";
	arc=none smtp.remote-ip=103.168.172.146
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3F5606A320
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 17:15:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE3F5606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pobox.com header.i=@pobox.com header.a=rsa-sha256 header.s=fm2 header.b=eoXscN5N;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=F/E61bVD
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.phl.internal (Postfix) with ESMTP id B6C0CEC0C30
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 12:15:44 -0500 (EST)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-07.internal (MEProxy); Thu, 19 Nov 2026 12:15:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795108544;
	 x=1795194944; bh=gG6SYRci2tonbzUE1w7siSj6Ls8OXf6NC7m+gjOpDgc=; b=
	eoXscN5Nj9q4jiqalo9mYF0oufP9vTqeoprACfIkmZXSVYSBo1IbIOiEyF4g1ztG
	V41UTpSvQ7Ipfy0yVIr0E2wFPas8Xxfdv6zHjNfKcHlJjuxWjGJUAYVak5dis90D
	7qVijXTKFf7TW3wZjmsmRh+j81HgLatgqi+RerrNukTm36gQUKbrPjCP4WR97XV5
	2myRZ3mOaAZdwOhUS1ZzkgWuMQaeGWo4rrcffd72YF0qmVz2s0jO+hO7IhupOOeL
	dQzIUEjDkH9AM+kHKXWvnh1AgOE9rXa1MIzJ6L0za0QZu98GsA/HZg3fmydCIa2J
	nXQy80Sz6B6OegrVW+OSAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795108544; x=
	1795194944; bh=gG6SYRci2tonbzUE1w7siSj6Ls8OXf6NC7m+gjOpDgc=; b=F
	/E61bVDv71yRAmjSEdxh1HDrVBVrEeRCip0SNHe7wbSIHi1L8wQpGI3EYErnXNPL
	zrijnqzPy6gch1lrtbh/tnXPhtciNoAbDYCYeqZad6OH9TCG4e+jj405AQrM6pRa
	DnzqEll/Caww9P6reFgzQ5WhkMhZZbBl1mHSOck3OMJV/BUADr+WXCTe25MBQIQx
	703PldSVy6STuGt899bx/vvOKjeErAlqt80KV6f2r2/Plz5k4Dte+RLmAUMjMfha
	NB3sjTbLfOVsDV1PFWR7P1n32OXZ2VadnVdGSrh19DdthbgWvzKrh/ntElwPFmPi
	YRLcVq9lkqQwE7G86JTig==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=pobox.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795108544; d=pobox.com;
	mf=PGJhcnJ5bkBwb2JveC5jb20+;
	rt=PHBhdGNoZXNAbGlzdHMubGludXguZGV2Pg==;
	s=fm2:rsa-sha256:aOa1rBklwjjsXdk4Ha2gRElyxP/HNjhlaou8tB4LtA+eHQ1
	U7w3TsdEwofcF0np0sTGvgNcORsd7uEUG9eJ81EViOa7f3sNT09pDCzHjNkXxUQN
	iXLC41LIxN1nKuvRXfkCfcHFKDWPb/nQxjF65ogvL7mRHosQB8piroLGq9wnCty+
	drECREYMsmx7UjFdf1WY2ZsTfmtYmKUpMCrCf90Slc40vP9bOqSkOtLwJXB1Cqpm
	LrxEpYmCVvs6KsNkGkP7oPmE3NaWUgsKBrxTkSlBfD+Ss+foSOv5uwk9JJSUrm43
	3j5LiKzTePnk5xc+zjXBWsCWzp4BWgZ4TE31G7g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=14;
	hn=cc,content-language,content-transfer-encoding,content-type,
	date,feedback-id,from,in-reply-to,message-id,mime-version,
	references,subject,to,user-agent;
Message-Instance: m=1; h=sha256:pGBvPEtwbu7eCKvBM3T0V7LOG3cvubmQlEJNZ40voiE=:mcQiFjwtrUBkBqjUTquaTH4QwwtpnIJfEZfCyR0L8fo=;
X-ME-Sender: <xms:wC7_ahG13iklQ3gcWzcRZsHrmPkk4u3lnv-bIpMg2RSvREtFZB_CyQ>
    <xme:wC7_ao4-4Mbud9COKEyxO8YjhR2D6Ok1fn3wDPBYUd1MjAwoPALZqPfcp-bDDebyU
    _dzZkhT2cIEMK5eECE0pjak4mEwjg2_VNGnNoH0t2F64bpjVJf_ZqRS>
X-ME-Received: <xmr:wC7_amwLtHv07LLjqho0b5svEC7yJGJs5DS7b1eFfxxU9SzZktwWxRNGqDoo-iBxGUjFCMZtZsr_t76nzb9py0RmigOeCkoQ>
X-ME-Proxy-Cause: dmFkZTGdkiJzzzCzyI1jy5TCHKoTNJWWxSYnGVXcajI8Ple3sqqoQ7ClKp8Xp95dRD+8kN
    fkkoAmQG1Iqer1YmKloXlDjLBpSncTLbPTAcwSOcw+WmULhGH3XEdK2zax2oHD73jN4p1x
    MNAWdJ7f+l2DL++6LToaYq/sYof7c/Ht0jgboQtc50Zn9BTSfKcr1izg2B/JOig804uP3l
    c13UyZMADySV4oT+xkhVF1xp9ZA0H+EIlGyIx67pV5LCASVyVAW9fk1zT7/kqFHmLh5P+u
    ZbBMQ/0T/YZtWnvUXzXeKrvbCqz1cuWsnLQhAZKOpUsoetGE7ecAR2NJDEkHyl1QkXhmfG
    F8THCmMXKVD6MSXfFQFbHvJTx/7Ds7G5OGMyfS0aKq8RQ2eXfM3J4ug8s0LNUlmRZmPelu
    N9T+FfwXkmH/8/wDOXTx1GrCmK054nUnGkx6pbWGpzmljLgLZ5ti5Tkz6OUzH712ICVpdq
    Kx05MTmL6Nk78/gMkQxrEESkrp/7GKML3dyZhKRiPpOxSyUwnQGFZtUZQKIjjc0ORlV/Y1
    bG3eR1dVyj76PYEc2CZ8ixx9KFEfvGbg9MCRhhmaZzmKRWUBFQUJE3Kqmsal3PXIH3mBpm
    R7xGvXl/I6CJY0ceq/filwkQsSuhsWlaqNXv8V8SRE17vBAzemuDkcMbo5QA
X-ME-Proxy: <xmx:wC7_anOaCKuQXkjTJbhQ6WHKsIB2vsSDgFml9agWU_c2hAE6a3Jqbg>
    <xmx:wC7_aslE8SrQY7X5e1wk9O_dCBHB3nhHqxlSqR4p0fQyvTOjbL7JIA>
    <xmx:wC7_asSVdNW_-Q1T0DkxhYSMhG8ggDCrSjq8S-EJv4pcbGUFYWzwLA>
    <xmx:wC7_arXY6HIQep-REVCLDJDBMIupplePXAxDHXyPC6Mvu3SR4LRwgA>
    <xmx:wC7_agF0KH_hOXMk3bFVfKo_fGME-BuPtlfnJmAiLBGpCBYY7Xklivaq>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 12:15:43 -0500 (EST)
Message-ID: <42da5e9b-1db9-410e-9c72-9f9f4e9489f7@pobox.com>
Date: Thu, 19 Nov 2026 09:15:42 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 1870/2651] Bluetooth: L2CAP: take chan->lock for
 l2cap_chan_add/ready/del
To: Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Pauli Virtanen <pav@iki.fi>,
 Eulgyu Kim <eulgyukim@snu.ac.kr>, Jaeyoung Chung <jjy600901@snu.ac.kr>,
 Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
References: <b5b8bc11-35bd-45f9-adac-648c1646ac32@pobox.com>
 <2026-11-19-1-daily-reply-0006@kernel.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <2026-11-19-1-daily-reply-0006@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/26 8:08 AM, Sasha Levin wrote:
>> This is breaking the build for me with clang 23.1.6 (also 23.1.5) for arm64, amd64 and i386:
>>
>> net/bluetooth/l2cap_core.c:708:2: error: calling function '__l2cap_chan_add' requires holding mutex 'chan->lock' exclusively
> 
> Queued the missing annotations patch for 7.3, thanks.

Now I get the following when building the current 7.3 stable-queue
(commit 5252483124e6cf016c4a6f41fe1e44f5e1949648) with clang 23.1.6,
same config as before:

net/bluetooth/l2cap_core.c:128:9: error: mutex
       'l2cap_chan_hold_unless_zero(c).lock' is not held on every path through
       here [-Werror,-Wthread-safety-analysis]
   128 |         return c;
       |                ^
net/bluetooth/l2cap_core.c:125:4: note: mutex acquired here
   125 |                         l2cap_chan_lock(c);
       |                         ^
net/bluetooth/l2cap_core.c:147:9: error: mutex
       'l2cap_chan_hold_unless_zero(c).lock' is not held on every path through
       here [-Werror,-Wthread-safety-analysis]
   147 |         return c;
       |                ^
net/bluetooth/l2cap_core.c:144:4: note: mutex acquired here
   144 |                         l2cap_chan_lock(c);
       |                         ^
net/bluetooth/l2cap_core.c:4589:2: error: releasing mutex
       'l2cap_get_chan_by_scid(conn, dcid).lock' that was not held
       [-Werror,-Wthread-safety-analysis]
  4589 |         l2cap_chan_unlock(chan);
       |         ^
net/bluetooth/l2cap_core.c:4703:2: error: releasing mutex
       'l2cap_get_chan_by_scid(conn, scid).lock' that was not held
       [-Werror,-Wthread-safety-analysis]
  4703 |         l2cap_chan_unlock(chan);
       |         ^
net/bluetooth/l2cap_core.c:4741:2: error: releasing mutex
       'l2cap_get_chan_by_scid(conn, dcid).lock' that was not held
       [-Werror,-Wthread-safety-analysis]
  4741 |         l2cap_chan_unlock(chan);
       |         ^
net/bluetooth/l2cap_core.c:4769:3: error: releasing mutex
       'l2cap_get_chan_by_scid(conn, scid).lock' that was not held
       [-Werror,-Wthread-safety-analysis]
  4769 |                 l2cap_chan_unlock(chan);
       |                 ^
net/bluetooth/l2cap_core.c:4778:2: error: releasing mutex
       'l2cap_get_chan_by_scid(conn, scid).lock' that was not held
       [-Werror,-Wthread-safety-analysis]
  4778 |         l2cap_chan_unlock(chan);
       |         ^
net/bluetooth/l2cap_core.c:5295:2: error: releasing mutex
       'l2cap_get_chan_by_dcid(conn, cid).lock' that was not held
       [-Werror,-Wthread-safety-analysis]
  5295 |         l2cap_chan_unlock(chan);
       |         ^
net/bluetooth/l2cap_core.c:7200:2: error: releasing mutex
       'l2cap_get_chan_by_scid(conn, cid).lock' that was not held
       [-Werror,-Wthread-safety-analysis]
  7200 |         l2cap_chan_unlock(chan);
       |         ^
9 errors generated.

-- 
-Barry K. Nathan  <barryn@pobox.com>
