Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB5637754D;
	Wed, 20 May 2026 17:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296741; cv=none; b=GnL4mFrGOVcnZ2ZU+KgEWoAVB2LpyjcvpFcONwd9oG+yE00LwYhRgJXdGLFCs9heXb+KclA1u/4sUjKLNHsbJAP2Snqp/HFGGZf9YDj7rrymShza9fpbCNOxt/Ug+rVFy1pwWiq1UPgi6tX7JVYTIQflF7TZM/Zlv/VzHbsiaOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296741; c=relaxed/simple;
	bh=+7r8DNPq3aE/dM9McyZotINHzo6I1B6cE3Z4IJ+4Bos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5j2VTjdfJybefDytoi/11doSKRbIlPwCoQblvoXacdGrQRL7SV36mrau86Ak8aIAN9ZTyh9CnE6abWvnNiACfTFYofGPd4B9mlePXwVfhdNJ7nQL0N7mwct7ezmP4k2L/j92OIxB6lpfZf45MrMSNYZJTCE5Kb/nCMJkMoPPPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnWUgYwQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnWUgYwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4145F1F000E9;
	Wed, 20 May 2026 17:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296740;
	bh=gh58YGbBtreSyM5O9ZqebU0U+MZb10VFEGwysoPFJdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnWUgYwQBz9AaBbiIGhAyoOCiqBfYUNE+1OMVfbdwxiJf3GDCjI6CG87VBCkP5r1Q
	 CxxxEbSxSjEcaleqMo1ce4aVgL0fyYq+yGVphQBNbDc4XUNf0MSixuutLAoRt0hjvk
	 Z1WhwbWS+ab39Om+tEWA+nEWrEU7Pu5SdUtGkqY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0873/1146] tools/power turbostat: Fix unrecognized option -P
Date: Wed, 20 May 2026 18:18:43 +0200
Message-ID: <20260520162207.994175582@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Arcari <darcari@redhat.com>

[ Upstream commit ce012c966b518c53475ba9a4e979242d7322d819 ]

The '-P' short option (shorthand for --no-perf) is not present in the
optstring of the second call to getopt_long_only(). This results in
the "unrecognized option" error when the tool reaches the main parsing
loop.

Add 'P' to the second getopt_long_only() call to ensure it is
consistently recognized.

Fixes: a0e86c90b83c ("tools/power turbostat: Add --no-perf option")
Signed-off-by: David Arcari <darcari@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index bea574d7aa68a..d6b4fd17c5f37 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -11449,7 +11449,7 @@ void cmdline(int argc, char **argv)
 	}
 	optind = 0;
 
-	while ((opt = getopt_long_only(argc, argv, "+C:c:Dde:hi:Jn:N:o:qMST:v", long_options, &option_index)) != -1) {
+	while ((opt = getopt_long_only(argc, argv, "+C:c:Dde:hi:Jn:N:o:qMPST:v", long_options, &option_index)) != -1) {
 		switch (opt) {
 		case 'a':
 			parse_add_command(optarg);
-- 
2.53.0



