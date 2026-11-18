Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061383;
	b=BNemgO6JvQhwEPnGSSEW+lz4xLhauLKvPqAH65JFNxahSUXVrT+vqtG5NLRPy+NKtEQN
	 v9w2eP1TfCt/biB8ZOZWzAJORFVriDvvtwgn4VFsH66qoqIApW0veezIaxswu0vIyjuRi
	 sD6it9DWOo9JtAAeI3JBdrknVYUp0/Unqx9RLSN2So+310a27c35KMzkfyCInp+gVU67K
	 m6eE99k9hWYSLtMcTD5w3UMgfo9nVLJcggHpI/cDtI6VXMe5SUfynBISrOvpIoxX1IRb7
	 kahsieX5ZcWrwgGnKt8hn3RfVqLtwNSu/6/qjTMVYbVsV+oN7G5ddFP/gXE00dZwp5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j1XL0qtTKRDC4gbLv8Ht3Wy+yi+XvkzfFzDV5ulM9do=;
	b=i2O0SF4Nyz7YhDEiWgwATjIg7+N0+QF7hQ63IO8ZWXMhUU/YvVqH/mNrRw28QMhSuXUU
	 fZKXZoM6FwhAKf0RQ2OwX10bP6Qq7NZepmhvrHTHclPN4EDtBbRlPtmui4mBJUsy6AJjm
	 7uk+ilM7NhkmAfDK5nEXrQOUCV2fMtxFxE7eQGJEoZThgg22EbliA2v43ghakUct8WFCA
	 UogZfoPk/rrpi8B8AKZakT4HbxeTyED3ADjgEXxr27o2wSntGTohW1j6Zy/aHUR6Wn1rO
	 oO2gPCCnqhVsDWlNhSWMzBfq52xkD94uR7aqR3Aw6xWDgaC+h9F81jFyIIt42VC99qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QaKuWLob;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361D6606A320;
	Thu, 19 Nov 2026 04:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QaKuWLob
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF391F000C4;
	Thu, 19 Nov 2026 04:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061383;
	bh=j1XL0qtTKRDC4gbLv8Ht3Wy+yi+XvkzfFzDV5ulM9do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QaKuWLobntaPwnkyPrH1JXu8xVYt80Za8X4GlFmPzKmPutu/9pwfumoI+FShE32iH
	 fuHp3+VklmKMJbvg3k0tgsdrKqNYCdK3TXCmhYNXDC/PIFn0wIw8odMD10jX2rCXLV
	 Pftm4rovJnQU3qLPi72PMS58srlKyv/m4zuF089E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1533/1848] drm/amd/display: use right type for amdgpu_dc_performance event entries
Date: Wed, 18 Nov 2026 15:59:31 +0100
Message-ID: <20261118150023.553189321@linuxfoundation.org>
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

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit 99858eda764364bae733448c7eb79145d3d043ec ]

Some amdgpu_dc_performance trace event params are passed as unsigned
long but stored as uint32_t, cutting them off on 64-bit. Use the right
type on entry fields and on printk use unsigned format accordingly.

Fixes: 0cf5eb76e2b4 ("drm/amd/display: Add tracing to dc")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
index d898981684d5a..23e4c6c7c3db0 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -72,10 +72,10 @@ TRACE_EVENT(amdgpu_dc_performance,
 		const char *func, unsigned int line),
 	TP_ARGS(read_count, write_count, last_read, last_write, func, line),
 	TP_STRUCT__entry(
-			__field(uint32_t, reads)
-			__field(uint32_t, writes)
-			__field(uint32_t, read_delta)
-			__field(uint32_t, write_delta)
+			__field(unsigned long, reads)
+			__field(unsigned long, writes)
+			__field(unsigned long, read_delta)
+			__field(unsigned long, write_delta)
 			__string(func, func)
 			__field(uint32_t, line)
 			),
@@ -89,12 +89,9 @@ TRACE_EVENT(amdgpu_dc_performance,
 			*last_read = read_count;
 			*last_write = write_count;
 			),
-	TP_printk("%s:%d reads=%08ld (%08ld total), writes=%08ld (%08ld total)",
-			__get_str(func), __entry->line,
-			(unsigned long)__entry->read_delta,
-			(unsigned long)__entry->reads,
-			(unsigned long)__entry->write_delta,
-			(unsigned long)__entry->writes)
+	TP_printk("%s:%u reads=%08lu (%08lu total), writes=%08lu (%08lu total)",
+		  __get_str(func), __entry->line, __entry->read_delta,
+		  __entry->reads, __entry->write_delta, __entry->writes)
 );
 #endif /* _AMDGPU_DM_TRACE_H_ */
 
-- 
2.53.0



