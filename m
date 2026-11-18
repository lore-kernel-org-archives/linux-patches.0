Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061786;
	b=cLrQX+g3/1wkGY+RD+Z9XIf3FfaLGDygvCrIu+r1VfsBd7FWf9aFJBmG4tpsUCfVFsXF
	 NV4jLyBm+MANjObIpCovcCNm8CLjf+7Tvf6osuHpVGENyHko/aBcuQqpI9mvyPIUink1N
	 rUoMy5fkQciOa9pydlQauwKTqKBNVsOudcnofqMaMskhS83sxysHCXgjcFmHN7UmcGEwl
	 S6MPVkh7FRJisPcB40A7ZIUS4tWzDX7FonhlcILuVIkPaVKGeWavcNurJkdM8xrLFp6Cg
	 vkNaRdr+Gh8IV3mFT7dnWLvR2yFSz0QXe14jtkDJW2tPw9GKTYO7Hw4ZoTnH/VNu6Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U0fFae19tGtINhp0qSaJObvGtisXHHf5Hndwp/VSaBY=;
	b=vRaAQUV0fEI0HPUljbja6SZ3A1lsnkJsnbBCX03awGEjfOCormEjeq7nUcjJim0Zm1hp
	 0yFqa2tILRTj+uqNkYLREi9WuKIovCBTW07ZK/IKlnaU7vbcMBwYyI9eMvbMJHWCRAcVA
	 QbrseUKx6JgEx2fzA3KqVb0WWRk2wJtCGdJZpejD9z7qcOQ87OS8LiBNl06wjDP5aoKnX
	 N7jiPthbwQhc4gDKsjE/ixDsgeUFOywxiDfj+3gVnm2DcKTvRgEEsZiQzeCTutNwmrR3g
	 QaMlI5VHkXlhi+S39lhXQGDdV10463TXB+R4ZkKcJI+62l71DheqsDSN9XOSUGvZA6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2YjYIup;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49F6606A320;
	Thu, 19 Nov 2026 04:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S2YjYIup
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4782D1F000C4;
	Thu, 19 Nov 2026 04:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061785;
	bh=U0fFae19tGtINhp0qSaJObvGtisXHHf5Hndwp/VSaBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2YjYIup7L8GGQP5h1rfTB9nQ+FJ0XPXbGe0yUEhfYiodTtbTyMHH/I9ZDM7qJ0ve
	 jHKsGtI/XVR62cmSMd99KEDKxSel47GQAf/xnHBr5CKfR7lbCLwuaOPZb5iHpKQswc
	 8eRgX6BvHo1SswLy211BbbTe7GkV9ZpLlUcexVek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1676/1848] tracing: Print a signed histogram key as signed
Date: Wed, 18 Nov 2026 16:01:54 +0100
Message-ID: <20261118150029.966270202@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit d3e0dfc1ba49a0ab6aeddbb4bcde4bfc0e171a02 ]

A histogram sorts its rows by the key named in sort=, and for a key over a
signed event field it sorts them signed: create_tracing_map_fields() picks
the comparison function with

	else
		cmp_fn = tracing_map_cmp_num(field->size,
					     field->is_signed);

hist_trigger_print_key() does not look at is_signed at all. Every numeric
key is printed with %llu, so a sorted histogram over a signed field comes
out looking unsorted. syscalls/sys_exit_lseek carries "long ret", which
SYSCALL_FIELD() marks signed and which is negative on every error:

  # echo 'hist:keys=ret:sort=ret' > events/syscalls/sys_exit_lseek/trigger
  # echo 1 > events/syscalls/sys_exit_lseek/enable
  # (five lseek(2) calls returning -ESPIPE, -EINVAL, -EBADF, 0 and 100)
  # cat events/syscalls/sys_exit_lseek/hist

  { ret: 18446744073709551587 } hitcount:          1
  { ret: 18446744073709551594 } hitcount:          1
  { ret: 18446744073709551607 } hitcount:          1
  { ret:          0 } hitcount:          1
  { ret:        100 } hitcount:          1

The rows are in ascending order and the numbers are not, because the three
leading ones are -29, -22 and -9 rendered as their two's complement.

Take the rendering from the same place the sort order comes from: the event
field when the key has one, and the hist_field itself when it does not. The
same histogram then reads

  { ret:        -29 } hitcount:          1
  { ret:        -22 } hitcount:          1
  { ret:         -9 } hitcount:          1
  { ret:          0 } hitcount:          1
  { ret:        100 } hitcount:          1

A ".buckets" key stays unsigned here, and not because it is right.
hist_field_bucket() divides as unsigned, so the group holding S64_MAX also
holds S64_MIN, reported at

  https://lore.kernel.org/all/20260914054614.82A9B1F000FF@smtp.kernel.org/

Printing that group signed would name a range that does not contain
S64_MIN, so the grouping has to be fixed with it, in a patch of its own.

Link: https://patch.msgid.link/20260917045918.370993-1-donggeunyoo.kernel@gmail.com
Fixes: 7ef224d1d0e3 ("tracing: Add 'hist' event trigger command")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 7c3c8cfb873c1..c978dbd41ee0a 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -200,6 +200,14 @@ static u64 hist_field_pstring(struct hist_field *hist_field,
 	return (u64)(unsigned long)*addr;
 }
 
+static bool hist_field_is_signed(struct hist_field *hist_field)
+{
+	if (hist_field->field)
+		return hist_field->field->is_signed;
+
+	return hist_field->is_signed;
+}
+
 static u64 hist_field_log2(struct hist_field *hist_field,
 			   struct tracing_map_elt *elt,
 			   struct ring_buffer_event *rbe,
@@ -4706,7 +4714,11 @@ static void hist_trigger_print_key(struct seq_file *m,
 				   (char *)(key + key_field->offset));
 		} else {
 			uval = *(u64 *)(key + key_field->offset);
-			seq_printf(m, "%s: %10llu", field_name, uval);
+			if (hist_field_is_signed(key_field))
+				seq_printf(m, "%s: %10lld", field_name,
+					   (s64)uval);
+			else
+				seq_printf(m, "%s: %10llu", field_name, uval);
 		}
 	}
 
-- 
2.53.0



