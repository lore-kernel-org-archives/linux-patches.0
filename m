Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A4929CE7;
	Wed,  2 Oct 2024 13:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875841; cv=none; b=Xs8bjfCGvXB3TY1O8Ei7ZI4mKjf4YdQROxrEstCu/+XKcfIRdx0dyhvzvK1qpkYXULNI4XRIc21nxS0e5jCHbl916NWyvhZNGGGCTFr0CdRM523+XS2AYI9jiJm/1p+5YQzNZWr7dlmXeEZoi7AaviV+naigO0u1m9GOy+eKXeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875841; c=relaxed/simple;
	bh=bWofJRfBqsjGehwxRES0L/H3EpcKPI3Jll/Zk392asM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IN9G2MM9pXBeevC9RcaoZdmuVQSS/b/eP4Mt8yOaeAYxQ8cn/m/h21/W2GhuQjaDst+xNvVqfwgcXPGFteFBwq72O6i/4r3S4PNi8HXrM64ec4umfUeMhwKY8+OxAHnYtHEJ2IDzonPr5Sy3s9eZauIJhovRMZrkFJmlWFsUlRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5SAt2lA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5SAt2lA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F59C4CEC5;
	Wed,  2 Oct 2024 13:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875841;
	bh=bWofJRfBqsjGehwxRES0L/H3EpcKPI3Jll/Zk392asM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5SAt2lACnucVtwi7uZMU14swG3iqmDEmRLx1mOxqRmSVL9YZ3jc9KtUg5uCCMlKN
	 SGTjPqVdlHowPtF0JKy2TaDq/1+K7hOQzUuItEf6d4ny7TxqkkPFdwmA+4y0H2P5na
	 Q6zfP582YhY4UyMg0Vs7SAGVyJlTgrlfrwC7AH9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 239/695] kselftest: dt: Ignore nodes that have ancestors disabled
Date: Wed,  2 Oct 2024 14:53:57 +0200
Message-ID: <20241002125831.989005496@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 05144ab7b7eaf531fc728fcb79dcf36b621ff42d ]

Filter out nodes that have one of its ancestors disabled as they aren't
expected to probe.

This removes the following false-positive failures on the
sc7180-trogdor-lazor-limozeen-nots-r5 platform:

/soc@0/geniqup@8c0000/i2c@894000/proximity@28
/soc@0/geniqup@ac0000/spi@a90000/ec@0
/soc@0/remoteproc@62400000/glink-edge/apr
/soc@0/remoteproc@62400000/glink-edge/apr/service@3
/soc@0/remoteproc@62400000/glink-edge/apr/service@4
/soc@0/remoteproc@62400000/glink-edge/apr/service@4/clock-controller
/soc@0/remoteproc@62400000/glink-edge/apr/service@4/dais
/soc@0/remoteproc@62400000/glink-edge/apr/service@7
/soc@0/remoteproc@62400000/glink-edge/apr/service@7/dais
/soc@0/remoteproc@62400000/glink-edge/apr/service@8
/soc@0/remoteproc@62400000/glink-edge/apr/service@8/routing
/soc@0/remoteproc@62400000/glink-edge/fastrpc
/soc@0/remoteproc@62400000/glink-edge/fastrpc/compute-cb@3
/soc@0/remoteproc@62400000/glink-edge/fastrpc/compute-cb@4
/soc@0/remoteproc@62400000/glink-edge/fastrpc/compute-cb@5
/soc@0/spmi@c440000/pmic@0/pon@800/pwrkey

Fixes: 14571ab1ad21 ("kselftest: Add new test for detecting unprobed Devicetree devices")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20240729-dt-kselftest-parent-disabled-v2-1-d7a001c4930d@collabora.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/dt/test_unprobed_devices.sh | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/dt/test_unprobed_devices.sh b/tools/testing/selftests/dt/test_unprobed_devices.sh
index 2d7e70c5ad2d3..5e3f42ef249ee 100755
--- a/tools/testing/selftests/dt/test_unprobed_devices.sh
+++ b/tools/testing/selftests/dt/test_unprobed_devices.sh
@@ -34,8 +34,21 @@ nodes_compatible=$(
 		# Check if node is available
 		if [[ -e "${node}"/status ]]; then
 			status=$(tr -d '\000' < "${node}"/status)
-			[[ "${status}" != "okay" && "${status}" != "ok" ]] && continue
+			if [[ "${status}" != "okay" && "${status}" != "ok" ]]; then
+				if [ -n "${disabled_nodes_regex}" ]; then
+					disabled_nodes_regex="${disabled_nodes_regex}|${node}"
+				else
+					disabled_nodes_regex="${node}"
+				fi
+				continue
+			fi
 		fi
+
+		# Ignore this node if one of its ancestors was disabled
+		if [ -n "${disabled_nodes_regex}" ]; then
+			echo "${node}" | grep -q -E "${disabled_nodes_regex}" && continue
+		fi
+
 		echo "${node}" | sed -e 's|\/proc\/device-tree||'
 	done | sort
 	)
-- 
2.43.0



