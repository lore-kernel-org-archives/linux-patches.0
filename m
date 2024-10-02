Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDF81D0B8E;
	Wed,  2 Oct 2024 14:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877837; cv=none; b=ll42yw3X8sRjyceWO+BnLPAHUCCZCfc4FPYZMQvQ6HSpyA540w9JXajmkIWjDN7hoLHtq3CuIpfmtyCHBr8ypbewxYzszoCStYt8Tnr9fVQpTEDfUKxZr+4l79BCM9FTy/6nkACRwPb8RKtsfWD5qca4a79nZvYzLqN7JgLfTbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877837; c=relaxed/simple;
	bh=Wy6X+sLeHMjHCSzunhYiHf3PKEgbHRzumg5Oloi7DgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sQZHGm1BNW1rNaBtv2W+4JWmjHOXJaT+W9Znx9/1PmFaTrIK7aPPJOizw8QcS7bqi3LwCxSijowvREtIqa5N4yfM/n25xwRf+MS5zfbUiAGGr6tA1lWm15hikzQ/yEuZbFRXLetoqrPKLtXyPkO6FUgmYXOFqVGI6W43impuMDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3xU0Aaa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3xU0Aaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF9FC4CEC2;
	Wed,  2 Oct 2024 14:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877837;
	bh=Wy6X+sLeHMjHCSzunhYiHf3PKEgbHRzumg5Oloi7DgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3xU0AaaRr9XkhFGXcgVt0J32x/psgWvgW63ml0CYBkC0wrn3DrtVJlKZEQxy34ox
	 3gPPPwJQ4xTDv+QZXuuLQVLwK6JckMId71wRpKoLIFyAGdE1DZVEyUpojvsMiRcZR2
	 AIYvKQUotcywM1wQfKpOBZTrM56r1F2R1d7JJr6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 212/634] kselftest: dt: Ignore nodes that have ancestors disabled
Date: Wed,  2 Oct 2024 14:55:12 +0200
Message-ID: <20241002125819.472172219@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



