Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037407;
	b=FgrT9i0u57tBCwMluRfDkasly8Kg/z8ODSa4d43sWmon/ZxeMGJgOVy3hWM8VDdi738F
	 huRM90whFMmuQssm2cn55c3Z9zFvFT3cIp9OlPj+amSIYu5vJFyl/7XGzgK5h+PWiJUMA
	 FpdSy1lQzbvxA7Lya0QjMRdyifFlygzptPsyVJIPSj20iTx7Xi8fPJk36DDeou67tfZMf
	 67JOkBWH0LlvVUgBNs3/jfG3R3N7dZ/76UEhEuptAQB6rIBX3is8e3EzpzcJUAQtOsWHw
	 ZZmrK9m1JwE3u9m9uVeZsotXgsIKezpKRBxYIBBuy9SIRTj4WUhrQF59vbIoVK6iXHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ACaJezkNJksWxEBMd8A/o4zS6bhxPZj3cDHqvmn4Zo=;
	b=HLS4mxXsNPm4m8gSVjkNRRtSIlPd7hAxjTyIPVdAGTVxctrAnyuGUPS2CFww0i5yk1CJ
	 Qpt+r+rS+qolBexLXJW1eD2k363pHEaBQxNJoEi4smJ0MQrfsdpIRxiL53/g8SweWtGC6
	 IFOwQTk0hmXPJh/EmqN0vwNy7MyO4gEAl6vT8NEQdmwtDkv6LvKowgoyeXf0ObdPAdIbi
	 p3nxBg1qgjUxbUQY5s3hvRXNZ95qiY66qepoSypyleo4e4toyzsF/ikiqKYSfS+WNvblz
	 1keldOLJ0J93lasHJQcfhPKnEFxDXZ2XMb0Kk0vU4zYkyjHdweczphbzglcjjB1Onqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFXV+xjR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40C8606A32C;
	Wed, 18 Nov 2026 21:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFXV+xjR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102EB1F000C4;
	Wed, 18 Nov 2026 21:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037406;
	bh=9ACaJezkNJksWxEBMd8A/o4zS6bhxPZj3cDHqvmn4Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFXV+xjRcvDScQEiaM1fzNNIbomIiEv5JodhIKrhSKF+sWfPA674dfx+PKI8y/2OR
	 atvN3qnTqyftGEcXn0vR/B+pun55H66yLrJC6pZxp6ti+QR6G44y/xaiBs3Z9mG0qV
	 nQIuVZH7nGvgBgaUZS1UYEg0BToKpurTlwiYlnno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1391/3318] tracing: Add the bucket size to expr_field_str()
Date: Wed, 18 Nov 2026 15:33:33 +0100
Message-ID: <20261118150402.312144968@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit c027ed03bc03a0e82fc368eaad657584a4480c7a ]

expr_field_str() renders a HIST_FIELD_FL_BUCKET field as "pid.buckets",
dropping the count, and parse_field() rejects that spelling.

get_hist_field_flags() returns the bare string "buckets" and keeps the
count in hist_field->buckets. hist_field_print() appends it,
expr_field_str() never did. Nothing reaches it today, since .buckets is
refused on a value and no expression can carry one, but the next patch
renders histogram keys with expr_field_str(), where a .buckets key is
legal.

Append the count, as hist_field_print() does.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260914053443.981201-3-donggeunyoo.kernel@gmail.com
Fixes: de9a48a360b7 ("tracing: Add linear buckets to histogram logic")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index be6eb66a6808b..8c2bc07154f77 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1747,6 +1747,9 @@ static bool expr_field_str(struct hist_field *field, struct seq_buf *s)
 			seq_buf_printf(s, ".%s", flags_str);
 	}
 
+	if (field->buckets)
+		seq_buf_printf(s, "=%lu", field->buckets);
+
 	return !seq_buf_has_overflowed(s);
 }
 
-- 
2.53.0



