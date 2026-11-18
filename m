Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056466;
	b=rBPl2KDIPJlCClIlWFMM9+g7DnVL0hR6XvI83CE+vESKGACbREBF0YAbXx7LcAO5teL0
	 C4GpRF4hUcoE38DCxgqsOveilNfbfy3UICWsfmAkymVd4sMMg7WYgetXQlJuQat1g0iau
	 ca0dSB+cfA9A+LRWV9Itv52TNps+4K8BpPd/V4agfmWnmCgVqJgBXCqPhSVpSZKWE5YTk
	 +KHLX4rs+0TfSgqVbfoJdTVh/GiXI9zzBiuOr5MFCAPW6zHKfdPyOMEcox58m863jEKUR
	 9D3lx6dX9OLPZVYm69mXHgPx9gTgwO6sh9SAIleH4UyX7AWRvvUXUx1h1w4jPBbgsTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YiyBnuFvkNTOPjiN+nG7cPCxj23pSoLNk9cVWI/xof4=;
	b=1rRFKf9njMM3SNWgACNrElz+Be4gUy7QqVg/hOahFv3utuRxyTimDFqFjBvC4VejIyRl
	 BDGEpoz0BzTDOo9G85GkuMWCNYy6fek5VYQEf7H+trNQdVnvU7u4Cxu0wTFiLhZWsCC/x
	 IJGcFlq3x+hgYBbofyvkbeJIbsrAgDjZqurqE1ecg/BBFWCDfH2+HSchQCqHNFx9Z6i/L
	 AUKtp4paUN3v9HpmRlnsfgokbTtEryC9J9SuRtiV5mCeBWAdgYD+1u4MwxRA1S8ia5gtx
	 DBy54C1ywvcVMcBjZg3jBcIFroXUya/dfvbzt7J0op5SiY2j0opiK3/sWm7r01xGNgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=geknjXLv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B4A60A261F;
	Thu, 19 Nov 2026 02:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=geknjXLv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884771F000C7;
	Thu, 19 Nov 2026 02:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056466;
	bh=YiyBnuFvkNTOPjiN+nG7cPCxj23pSoLNk9cVWI/xof4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=geknjXLv1NVy8D2t8y6viW9MY83aZptysM/IzbuhwLPWm1ke3EKZvk8cUURFS2GYt
	 5GTUqvbxCSqWbOqyOcCulvVphuQKRjQsEEW5sRH2cr3h4rwe+YlsiEoOvFsHe7rYH1
	 t91EGZEKNN535sU+qH8NWFqpnkSP6mFzTYRuFplg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh Singh <kaleshsingh@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1999/2214] tracing/histogram: Document expression arithmetic and constants
Date: Wed, 18 Nov 2026 16:01:15 +0100
Message-ID: <20261118150130.758759166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh Singh <kaleshsingh@google.com>

[ Upstream commit 2d2f6d4b8ce738ef43fc3436b43cecd2fea64152 ]

Histogram expressions now support division, and multiplication in
addition to the already supported subtraction and addition operators.

Numeric constants can also be used in a hist trigger expressions
or assigned to a variable and used by refernce in an expression.

Link: https://lkml.kernel.org/r/20211025200852.3002369-9-kaleshsingh@google.com

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: 289e2a775de4 ("tracing: Clamp the printed end of a histogram bucket at U64_MAX")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/histogram.rst | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/trace/histogram.rst b/Documentation/trace/histogram.rst
index a78350a8fed43..7a68a5ac33a86 100644
--- a/Documentation/trace/histogram.rst
+++ b/Documentation/trace/histogram.rst
@@ -1763,6 +1763,20 @@ using the same key and variable from yet another event::
 
   # echo 'hist:key=pid:wakeupswitch_lat=$wakeup_lat+$switchtime_lat ...' >> event3/trigger
 
+Expressions support the use of addition, subtraction, multiplication and
+division operators (+-*/).
+
+Note that division by zero always returns -1.
+
+Numeric constants can also be used directly in an expression::
+
+  # echo 'hist:keys=next_pid:timestamp_secs=common_timestamp/1000000 ...' >> event/trigger
+
+or assigned to a variable and referenced in a subsequent expression::
+
+  # echo 'hist:keys=next_pid:us_per_sec=1000000 ...' >> event/trigger
+  # echo 'hist:keys=next_pid:timestamp_secs=common_timestamp/$us_per_sec ...' >> event/trigger
+
 2.2.2 Synthetic Events
 ----------------------
 
-- 
2.53.0



