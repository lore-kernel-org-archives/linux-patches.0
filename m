Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060917;
	b=LhoFIrqjbAyUudBMOdTuSkvderqjM1Do1sMQme704qnDmpn+/AZb+jxesg372vVvLy1E
	 CJqmmf30pb7CHiBZa0r6iD347dLhiJF8SN+7IBTzAjJWeDwhY/VtSymuNW5CV2WPK600A
	 ivKDSQ8htzqnLXJRk1f53r7zYWEqVlRZR083dfsMdRTXEJfIGV3b5I/9fdznR3hgV8Hrb
	 V17GtsvkVKzDe/S+vIp7RWSdwKML9PcJ4ALN7B44eX3gIlrEFd6ums9t8XI8zVA2mfkYR
	 uVS03CYmHfNmNstNCzsFigCeDMb6u9F9q0usu2Jc9UAr3msXY/5fuiha+IQjQrtSaFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LPB9S6W4CoWOvKdxpi8qwOssfdhgQWqqhcqY+DRWQc0=;
	b=5S9Z+h+5yazmaBPcECYwXH5vWeaTza0fP05ZnI5CWqfW6fh405gtph+ejtqx3mIQwyJr
	 WjaSpP08673WULgSud9N9h4PUvreOTnZ9+SK5UzyGXH17tb0/PPrUN2eDJBW5HlqElwdw
	 oIS4xOITKrYdiR5LVvry/lOeOaCvn2/ymO9+IgwufVOwyKJLuIGhP38KShU25e2BOepyM
	 V9hwdZkOA5iXYvziclwKaeJcMhjkUTWrWk+eggWVO4s6hTi8lg7qEz1p28ZIVmArXURJh
	 CdxIO9jBNseHxj6x9YZQlWQ+YsvC7Vgux0D4awMAIfzlG615176RBIOz7Cd9ivmGs2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u39J6/tV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1F8606D81D;
	Sat,  7 Nov 2026 14:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u39J6/tV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1744A1F0089F;
	Sat,  7 Nov 2026 14:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060917;
	bh=LPB9S6W4CoWOvKdxpi8qwOssfdhgQWqqhcqY+DRWQc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u39J6/tVH1XcOWCQT4Jqmwi0kboyOApVoILBrWj4fhgSmDDvHipVHalDsP/g6Lx/b
	 IUZQuNyYcQWQ+jgu8DFleWqVXGEp1/F78W77G8zOAimLij9aTB5FSJFiQUOBb8bIJI
	 dLPlcd42Lwy61zzFj3875Wi561vzhjxLpg6T6RtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0285/1536] selftests/ftrace: Force C locale in ftracetest
Date: Sat,  7 Nov 2026 08:38:21 -0500
Message-ID: <20261107135005.665650791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Rui Qi <qirui.001@bytedance.com>

[ Upstream commit c13fcd3951dcc19524ce0b3e852844b16cd32b22 ]

Some ftracetest test cases parse command output by matching English
field names. Tools such as readelf may localize their output via
gettext, while ftracetest currently inherits the user locale from
the environment.

If a translated field name is printed, parsing can fail even though
the tested kernel behavior is unchanged. For example, add_remove_uprobe
can fail to find the ELF entry point and then write a uprobe event with
a missing offset.

Export LC_ALL=C in the top-level ftracetest runner so every test case
gets stable command output by default.

Link: https://lore.kernel.org/all/20260807081512.2974757-2-qirui.001@bytedance.com/

Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/ftracetest | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index cce72f8b03dce..ee3b950e872f6 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -7,6 +7,9 @@
 #  Written by Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
 #
 
+# Keep command output parsing stable regardless of the user's locale.
+export LC_ALL=C
+
 usage() { # errno [message]
 [ ! -z "$2" ] && echo $2
 echo "Usage: ftracetest [options] [testcase(s)] [testcase-directory(s)]"
-- 
2.53.0



