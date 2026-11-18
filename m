Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032188;
	b=FUm7/otrMrjOAy0niUnYaKB6d1rQLSi/kETGjp5Q8w7Ga1snXYKaEAk0U3utbGtINrnt
	 KheCjB9ozeekgZ2ppu10YMotDotMNj0Pagc9o5Nk6CXCze/FcQPDZegONB6w0WUtcMzVL
	 Q0Jj2wIaQcvUz3pXfeP+onvVXfh5neXmVZsCBoam+iEOS4P2uPksl5l13or5aX6yfHZPF
	 c4hKQvL4te1NmbfoTo9bsg7YNuhxtgjxKtDAp4f7Xny87EC0vPD7rY3IEVhxd2qEfGnKb
	 cz7sE+FmxKBCzk2I8N68aLzIa0Fv7649tuNJONpaFmgspTuh1xtJF99p1VbQ0c7QhEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ook1AZKKyX4YUc+faPRq7N/IdxA27edEwX5snVVrDpY=;
	b=uaMqb1I66mj+ILYGu03IPKP9pU9XHRaWlXsQZe8t+UI55jVa/xrir2ASpeX5oI+bLwxD
	 ACsoHw+mSQwalpKtyFxVFmoE9jmVHraaid9z6nbzVEQZXn31FD+Zra1gw2msEgHUoCOEi
	 bK9Eb2Mt1bytp6tS3kBJFil9uPrWPQy0xgpilGE0BUOjv9e2ug3Oko95jVTrZLLEagL7h
	 t/yKjU+mhWvQlMVXDqWsgIwx7DJ27pgQGDIh78MkHwRUKTKBCkFzhDGN/GmpCf4rqYwlK
	 52BiXCNAdU0q8MA51KmfGBcZ5/ejLo9RInfKhL9fXot6V/6rYSu1+56IeEFhwl7pZGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i/PtllQu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E12606A31C;
	Wed, 18 Nov 2026 20:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i/PtllQu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4741F000C4;
	Wed, 18 Nov 2026 20:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032187;
	bh=ook1AZKKyX4YUc+faPRq7N/IdxA27edEwX5snVVrDpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/PtllQuqb24n1LXL8ijeAxEeSvrPg1nXdOPh8OG2jMo2noKuPFFB2juHyyphL/D0
	 d5wgz3o9axeLXGzz7oI+zzYseedQLKxHOC7bTmhji0PYdvY82mHp11IsKd2pCB+fcL
	 wa6HP9a1dw5G/ZqzzrD6kk1sVcvUx7qmWkMNRIPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1321/1756] tracing: Print a signed histogram key as signed
Date: Wed, 18 Nov 2026 15:57:28 +0100
Message-ID: <20261118150102.018386177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1b597f735f851..56a5fad3bacf2 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -272,6 +272,14 @@ static u64 hist_field_pstring(struct hist_field *hist_field,
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
 			   struct trace_buffer *buffer,
@@ -5560,7 +5568,11 @@ static void hist_trigger_print_key(struct seq_file *m,
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



