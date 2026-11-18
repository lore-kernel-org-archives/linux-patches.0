Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017460;
	b=vVD5O7tUTb36u2mQWQangh/eKPl+20qYHbSBU0ehmA78AAuuLCkrCn5YTQ6Mms6OoHrE
	 Wu624adm1A0kUe+KQHlrKYDi3YtvE248S1HgGxGCgkqYwzoJkY2Nz0+j6o9eaBfyuzDmr
	 ddonRhOKBJjPlv8/Dmsby5tTXkiiEQCQBQdCAxvyYyZdqu+r7qmQZC67UDhFRCxBGp29v
	 BMfTeEwDjshfLy1+pU3X7gJX6LSa9jH0SYSLnkvuuC34aFBiMpjjAZuqnkWmd3AahY8VM
	 ORcDnLuH9mU9ZNthAyqEH/jwgGWWWlVXE2HwvdZOrVrBkJA0DfXfWcQicGTKOd0DQmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a0Zy7W9BDvAnRT+ORA68jsK07lG8LGxCbni42CUfUYU=;
	b=z8S4CP90kDjEpP+QgIV1QtDUA9QOlLRar5LaV05Czagedt8px9YjrOIvMJ1rqsy2r1Jb
	 tVlOlFdzP5q5pfLEBKunh+Wjwo7VYFeYZp5ejPxJwNjLEI1WMh0UzSRIJvd8VnhThM68U
	 nd60F0uW5raWd5gbHwgeNwSKA5zLyC5srZKDQJ+6fHK1o2dDNxGOn08XipBQzjw7xbgr/
	 ZK3fQOr88YtShRIweEQyYJIlwNYbEkVcM1Z1W0ZRbCjSybBVlyL5d1MfgTMhRqOTN80Ns
	 SyLJSSeuySyASL2KMAe4Cts8ZAP6WmcN4llAcSRBhqnhyXtKTUBThKPUqRVVXHHXwTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZuzUDln;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9E4606A320;
	Wed, 18 Nov 2026 15:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZuzUDln
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C7D1F000C7;
	Wed, 18 Nov 2026 15:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017460;
	bh=a0Zy7W9BDvAnRT+ORA68jsK07lG8LGxCbni42CUfUYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZuzUDlnspya9CMTb+GcXZStHkT67IahuvOUPaz0qgwcTae8xYj+oQc1AL8jBp1bN
	 7jnO89L9UCAX/bTn6U3Cwrp+M0ULTQtBGhA2feH2I5ZdjnY86RPF/em9HQXufu/zku
	 Ifu+nnerZrmUbRW6uBsvOChOSxJOaE59+I32CjWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0892/2651] x86/resctrl: Update documented unit for the "activity" event
Date: Wed, 18 Nov 2026 15:35:32 +0100
Message-ID: <20261118150319.979071082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit a17d099481bd11f0911993a8e69992269f92ad12 ]

The unit for the AET (Application Energy Telemetry) activity event[1] is nF, not F, see
https://github.com/intel/Intel-PMT/blob/main/xml/CWF/OOBMSM/RMID-ENERGY/cwf_common.xml#L9

Fixes: a8848c4b43ad ("x86,fs/resctrl: Update documentation for telemetry events")
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://patch.msgid.link/20260915190431.18189-1-tony.luck@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/resctrl.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 6b641c3cee644..fd643cea47269 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -658,7 +658,7 @@ When monitoring is enabled all MON groups will also contain:
 	during execution of instructions summed across all logical CPUs on a
 	package for the current monitoring group.
 
-	"activity" also reports a floating point value (in Farads).  This provides
+	"activity" also reports a floating point value (in nanofarads).  This provides
 	an estimate of work done independent of the frequency that the CPUs used
 	for execution.
 
-- 
2.53.0



