Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C641A0BF3
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 02:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784774541; cv=none; b=ZWxIqiJfcf8pEWL2/4fVKfGyh1tlqLrhfJCganYq2jjU6lXVRJjvhVJEY2vQsjg3JoYqxEYJiYXOet3Um2gGDxqYQvRn/MWmQ8W6DX4tifK9/HFH5JQ5Z609QD46kxTrZGo3xTxToYuL+SKhdFVbLb+DaTA8o82+Ur6a4pCLTOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784774541; c=relaxed/simple;
	bh=2vv86He2Cb3gpCWkn2XOn8agTasMnYtb1DHPuU22gFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PrI2XeXmyDfVlRBa2y7HznwjKCZd9fZNU2TAa6Us3HtivCjM4MUrFNZ1ISR7EyoE07jx0o4VkmNEZJ8udXS8REFL399g2WzW1rF/JKuATDYivHlsusKgRdKrY7DWIIay0Tqn/E9u2s4Ze6Y8tYKyqpb1FP+9UDxdbZIXKcn5eNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=DcwSnnUr; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=oYR4o5zp; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="DcwSnnUr";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="oYR4o5zp"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id DE3A71D0000A;
	Wed, 22 Jul 2026 22:42:17 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-06.internal (MEProxy); Wed, 22 Jul 2026 22:42:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1784774537;
	 x=1784860937; bh=8fxfs3/x6GJoHNj/GVxfzinax7FSYh5fmegjEbBcMYo=; b=
	DcwSnnUrBQNnx5pQ2tpjNCyGBU1TFjhknDA9GWmAV6HcWA71X2+q1TzzEqheA1XD
	/Th5rbp7RvdWfseHSkOuJNv0hKhsVUaPt1CNdmBcC7VosyLhpugCYXuJEJbkG2l6
	BbC0wgbzpcxzKeYHdY32x2NbZr5zLPeQD8W5+aAcEuu9Wq4pYB7UC+5EgBiaENdx
	v/13Nru/JqA2tHV2h/dSWz4oGMfnMrFS51E13S5Mfjq32chNxAaATYi/LAgyU1Hq
	psl8qO6kDtTgE+DMrzWsJNynw31uZ/f0YXmekrhz5TVqNHm+PIEZ4AmZ16BLppbO
	APoUxOrkGUEjLllKQ8aXig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784774537; x=
	1784860937; bh=8fxfs3/x6GJoHNj/GVxfzinax7FSYh5fmegjEbBcMYo=; b=o
	YR4o5zp72w6LidoBc7LGJxZd11/HUzz1eoREteSTuRcPULOkuA42SyIp9a68GEAF
	IONUO6nXzrIWvjW4ZPS3LXg0pBKa4W2YkqsyhdWUZDoMKRLp/phWWB6nEM8B1FRV
	F0j1/xPA+WKdVmH+0fju7PPF9QJ36VSHknPMkZA+1dqh5FGr3n2YIRFi7pTQRRY1
	iaUOWcslEHi6lDeO60S6KwQaBk7aH2igSrc2+/B5HtZ1AMAhsJi6AHD0UFK6A+D/
	N+ywsz5bfgTvvnuQpWDK4KrWzPybHW8vlgSEQNfSUZ3LczEdcdQmCHvPbAbPuHUX
	ldnPnNklnBSO51QbeGTcg==
X-ME-Sender: <xms:iH9hat_p-qyOwwkEDasTbNckRU9KpCimyv83MfMOMaXV7IK1NcnSMA>
    <xme:iH9haoON9XWoHEj_6wj2SBO8BCy9HcuS0L_l4wZQcYaod8DHJgcPSwgZC1_ETKc30
    z1Y0wrNdkhGmEKztWqi330R5wRkWcYWnP3zMPaZQmYFsX5x_DHbGw>
X-ME-Received: <xmr:iH9hapD9Xn46FW3o0QRsAo89nb_lNNbhpr012yOjbV28hdY3zxZttVxXSUA63TiUjwmyJDWUbctsyQ9HlFg-Q14wGMC7EMhv>
X-ME-Proxy-Cause: dmFkZTE9aMZQqq+LBF85386CUfA6QICw7pVFc8qKKBiuIFtSPRu03+0dPWJWKJ1QvPdPx5
    BlISSGCIy5nX8WFPni27zg+WKWBMTuMK7Y2YoDxKHnTxSSAvXibqyOTIsBsUqA4e3Fa70K
    FuG85IXvHhOGbqHHoMr7mCpDuH72u+H2y8NgWPFN+19U1sZ5o1b9XOwytxZtsjMpakwaUy
    HNQCQdfKD6Sy/mTnR0fHRKbV0aeUEe0oFdWiNjNv4jePqiN5EK19U9xnvfg0kp/TstParX
    m7BfoXWWxdszSq1U/Wet1yXItJktaZL7dWj5OHgauE3ntKTCx/hs6eDthc3uh81oxgA0V/
    EmWaWcDvXrpOEf+F4tIeU9VgiJSTjjnwaiOPN26mkPi5lZYneq4Uwk1JZOBAS5VL1FKuJW
    3GsoFKX+rGYYs2+pTQWtHfFoTQqhGfxOsWdfjQXjeJJ/6Jl3lZFPlnbzKP31W+GEnZgVUq
    MiPiIW7TbsycV9IF3lIhh+dlJQUKSwJNt2FiLKNfLjajXpAx8IMW2YT/kYmJE42XPC88sM
    6FWq557acKWj8C2SgLOqa07TWMFY7R8ZIYSM3LUyuPc/+Uz42OgYQ/qGVYLn7w/q0hrN9t
    t8ilik0DCwG9nv+DwMfLhCZ7PEiPOoY0roLaMnY0zGREJ/YJBlRAnNJ559vw
X-ME-Proxy: <xmx:iH9hakOiq9TQ-j6tl89tvJT_3s_p14_iIIBwc1HS204S36_9wKbmWg>
    <xmx:iH9haocrjuro2aCijoXjyx3eU29By0uJvBn0NJWy0TF-TyOZ7TjVQw>
    <xmx:iH9hat7F3WkrsFIdUxOqfqWVeFYSl4dW3KONwToAE551lVOv7xlDGw>
    <xmx:iH9haiIBUgeacX_cJzHa3fCIL_9N6JebnJqQG5mW_-JJPWTfVHkxpQ>
    <xmx:iX9hau7qhON8fPlgey1KUoPThLgCnJ_rUVZ6LMNkNFB8MhPZATOEotwc>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Jul 2026 22:42:15 -0400 (EDT)
Message-ID: <1d60d21d-ea26-4502-afee-c49c750df1e9@pobox.com>
Date: Wed, 22 Jul 2026 19:42:14 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 137/699] tracing: Prevent out-of-bounds read in glob
 matching
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Yuan Tan <yuantan098@gmail.com>,
 Yifan Wu <yifanwucs@gmail.com>, Juefei Pu <tomapufckgml@gmail.com>,
 Zhengchuan Liang <zcliangcn@gmail.com>, Xin Liu <bird@lzu.edu.cn>,
 Huihui Huang <hhhuang@smu.edu.sg>, Ren Wei <n05ec@lzu.edu.cn>,
 "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>
References: <20260721152355.667394603@linuxfoundation.org>
 <20260721152358.800887633@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260721152358.800887633@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 8:18 AM, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Huihui Huang<hhhuang@smu.edu.sg>
> 
> commit 0a6070839b1ef276d5b05bedfb787743e140fb17 upstream.
> 
> String event fields are not necessarily NUL-terminated, so the filter
> predicate functions (filter_pred_string(), filter_pred_strloc() and
> filter_pred_strrelloc()) pass the field length to the regex match
> callbacks, and the length-aware matchers honour it.
> 
> regex_match_glob() was the exception: it ignored the length and called
> glob_match(), which scans the string until it hits a NUL byte. Some
> string fields are not NUL-terminated. One example is the dynamic char
> array of the xfs_* namespace tracepoints, which is copied without a
> trailing NUL. For such a field, glob matching reads past the end of
> the event field, causing a KASAN slab-out-of-bounds read in
> glob_match(), reached via regex_match_glob() and filter_match_preds()
> from the xfs_lookup tracepoint.
> 
> Add a length-bounded glob_match_len() and use it from regex_match_glob()
> so glob matching always stops at the field boundary. The matching loop
> is factored into a shared helper so glob_match() keeps its behaviour.
> 
> Fixes: 60f1d5e3bac4 ("ftrace: Support full glob matching")
> Cc:stable@vger.kernel.org
> Link:https://patch.msgid.link/da1aaf125fc3b63320b0c540fd6afa7c3d5b4f1a.1782836943.git.hhhuang@smu.edu.sg
> Reported-by: Yuan Tan<yuantan098@gmail.com>
> Reported-by: Yifan Wu<yifanwucs@gmail.com>
> Reported-by: Juefei Pu<tomapufckgml@gmail.com>
> Reported-by: Zhengchuan Liang<zcliangcn@gmail.com>
> Reported-by: Xin Liu<bird@lzu.edu.cn>
> Assisted-by: Codex:GPT-5.4
> Signed-off-by: Huihui Huang<hhhuang@smu.edu.sg>
> Signed-off-by: Ren Wei<n05ec@lzu.edu.cn>
> Acked-by: Masami Hiramatsu (Google)<mhiramat@kernel.org>
> Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>

5.10.261-rc2 does not build for me (nor does -rc1):

...
   LD      vmlinux.o
   MODPOST vmlinux.symvers
   MODINFO modules.builtin.modinfo
   GEN     modules.builtin
   LD      .tmp_vmlinux.btf
   BTF     .btf.vmlinux.bin.o
   LD      .tmp_vmlinux.kallsyms1
   KSYMS   .tmp_vmlinux.kallsyms1.S
   AS      .tmp_vmlinux.kallsyms1.o
   LD      .tmp_vmlinux.kallsyms2
   KSYMS   .tmp_vmlinux.kallsyms2.S
   AS      .tmp_vmlinux.kallsyms2.o
   LD      vmlinux
   BTFIDS  vmlinux
FAILED unresolved symbol filp_close
make: *** [Makefile:1228: vmlinux] Error 255

I bisected it, and this patch is the culprit. Reverting it fixes the
build for me.

This is happening on fully updated Debian 13 trixie, compiling with
gcc 14.2.0-19. The kernel is being built for an amd64 target. This
failure happens whether building natively on amd64 or doing a
cross-compile on an arm64 build system.

For what it's worth, 5.15.212-rc2, 7.1.4, 7.1.5-rc2, 7.2-rc3, and
7.2-rc4 are all unaffected.

-- 
-Barry K. Nathan  <barryn@pobox.com>
