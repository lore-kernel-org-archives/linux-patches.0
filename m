Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049358;
	b=Ajyj9WkmDA7sooO8u4S+NwQWK07M5JzkXcN3zuklsg1WZoyWHbuk7T7MkKwayvfWGWHZ
	 11q5fEHPSB+Bmv5y3sTKM8hBGZoGhYrpHO344PsI0kW+117KpXagsybRnnpONOgo0PYW4
	 Y6AcCCqljdv1Int6U+Up+Hs4QY/CYdIJv4sk2O98XQUHFXhWwpTPGOwO9Bp+tfjkvTw55
	 //hiSPlCuBey1zKVW8A7IxAFXpURnr8yj+MK3fry/xOys+AIxShQ6uWsgOot6glE8bCAc
	 Qqa+jwEOShr8JlyLvtZiR7tVLgB63D4zV1kkBciE4g0ExshnOqZ5z97ERR45w2q06ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=clKvP5IZu932/N9M6vJtP3zyLorIDfYA9CXN2K9IY84=;
	b=jdVe2FII/T8VPr+exrCu+JDTb1//tjfKhD4uilxdtyc97AzuiahaQ0hhRaMTKE2m61iV
	 wvYdNy2oSt/2b9HZiSrzkh8dEZE3557Yz8rsmH7cobFbV0BCx80rElDyUfcZ25lN65XQ+
	 Q0DMIDDbFLssISYs4yRl8ertgxPdr/25/kNYGmPKZwnmUVtbtsUwUfp3PvPu/tpfu3mOJ
	 1kP1vzEj22ZmFg8Gne9PVmvKXYk4Vc2QE5x299PwhL/4g5Y7lhqFuktDGgW4x7algOC+L
	 9kRjvrcR9ohnbFy/w5Qgo8E2L1HBU+0fFcTRAVXszxeG+EzKNu//lmOaBd4Bwq7rtjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BsyX05Vc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BA6606A31C;
	Thu, 19 Nov 2026 00:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BsyX05Vc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D551F000C5;
	Thu, 19 Nov 2026 00:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049358;
	bh=clKvP5IZu932/N9M6vJtP3zyLorIDfYA9CXN2K9IY84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BsyX05VckyvUKJBe7q+DEe1usimijhTKVdvM2qfiynhUqSV/OFMaiuZtgen1mdc0I
	 pJ8eYv4ExB07mKqUv4TAN/oqON/B7O0Uud4NbsTXp1rB7cmT8+lNuuYbNb08k8EneU
	 36/v1CV2jvxNtr/FzP9fzckfNzcn48ym5GuOs88M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2316/2857] drm/amd/display: use right type for amdgpu_dc_performance event entries
Date: Wed, 18 Nov 2026 15:55:50 +0100
Message-ID: <20261118150324.921802054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index d7813017f7c24..7bc89954882ff 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -74,10 +74,10 @@ TRACE_EVENT(amdgpu_dc_performance,
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
@@ -91,12 +91,9 @@ TRACE_EVENT(amdgpu_dc_performance,
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
 
 TRACE_EVENT(amdgpu_dm_connector_atomic_check,
-- 
2.53.0



